import 'package:bloc/bloc.dart';

import 'package:snacc/blocs/booking/booking_event.dart';
import 'package:snacc/blocs/booking/booking_state.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:snacc/models.dart';
import 'package:snacc/database.dart';
import 'package:snacc/config.dart';

import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

import 'package:connectivity/connectivity.dart';

/// This bloc handles all creation of vouchers and objects in the database which cause vouchers
/// and spaces to be booked
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingState get initialState => BookingState.initialising();

  @override
  Stream<BookingState> mapEventToState(
      BookingState state, BookingEvent event) async* {
    if (event is InitialiseEvent) {
      ConfigLoader configLoader = ConfigLoader();
      await configLoader.loadKeys(); // Get the API keys

      _initSquarePayment(configLoader);

      // We need the user info if they make a booking
      User user =
          User.fromFirebaseUser(await FirebaseAuth.instance.currentUser());

      yield BookingState(
        restaurant: event.restaurant,
        date: event.date,
        day: event.day,
        isInitialising: false,
        numberOfPeople: 2,
        user: user,
      );
    } else if (event is NumberOfPeopleSelectedEvent) {
      yield state.copyWith(numberOfPeople: event.numberOfPeople);
    } else if (event is TimeSelectedEvent) {
      yield state.copyWith(selectedTime: event.selectedTime);
    } else if (event is BookNowPressedEvent) {
      try {
        yield state.copyWith(isLoading: true);

        if (state.selectedTime == null) {
          throw Exception('Please select a time');
        }

        if (state.user.hasCardDetailsSaved) {
          // use existing card details to charge payment...
        } else {
          _onStartCardEntryFlow(); // Start the Square SDK card input
        }
      } catch (e) {
        yield state.copyWith(error: e.message);
      }
    } else if (event is ErrorShownEvent) {
      yield state.copyWith(error: '');
    } else if (event is CardDetailsFlowStartedEvent) {
      yield state.copyWith(needsToEnterCardDetails: false, isLoading: true);
    } else if (event is ErrorEvent) {
      yield state.copyWith(error: event.message);
    } else if (event is StopLoadingEvent) {
      yield state.copyWith(isLoading: false);
    } else if (event is CardDetailsEnteredEvent) {
      yield state.copyWith(
          isLoading: false,
          showConfirmation: true,
          cardDetails: event.cardDetails);
    } else if (event is TransactionCompleteEvent) {
      yield state.copyWith(
          isLoading: false,
          showReceipt: true,
          showConfirmation: false,
          voucher: event.voucher);
    } else if (event is OrderConfirmedEvent) {
      // When the user confirms they wish to book a voucher
      yield state.copyWith(isLoading: true);
      int selectedHour = int.parse(state.selectedTime.split(':')[0]);
      int selectedMin = int.parse(state.selectedTime.split(':')[1]);

      // Create the voucher object based on the data stored in the current state from previous
      // actions such as entering their card details and selecting the booking time etc.
      Voucher voucher = Voucher(
        restaurant: state.restaurant,
        numberOfPeople: state.numberOfPeople,
        bookingTime: DateTime(state.date.year, state.date.month,
            state.date.day, selectedHour, selectedMin),
        user: state.user,
        cardNonce: state.cardDetails.nonce,
        status: Voucher.STATUS_CREATED,
        createdAt: DateTime.now(),
        bookingDay: state.day,
        discount: state.restaurant.discount,
      );

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        transactionFailed('No internet connection, please retry later.');
        return;
      }

      voucher.createAndSaveToFirebase();

      // Listen to the location that the voucher was written to until a change occurs.
      // This change will be the result of the transaction attempt to charge their card
      Database.listenToDocumentAtCollection('vouchers', voucher.id)
          .listen((change) {
        if (change != null && change.data['status'] != null) {
          switch (change.data['status']) {
            case Voucher.STATUS_TRANSACTION_COMPLETE:
              change.data['id'] = change.documentID;
              Voucher.fromFirebase(change.data)
                  .then((newVoucher) => transactionComplete(newVoucher));
              break;
            case Voucher.STATUS_TRANSACTION_FAILED:
              transactionFailed(change.data['error']);
              break;
          }
        }
      });
    } else if (event is TransactionFailedEvent) {
      yield state.copyWith(
          isLoading: false,
          showReceipt: false,
          showConfirmation: false,
          showTransactionError: true,
          transactionError: event.error);
    }
  }

  /// Dispatches an [InitialiseEvent]
  void initialise(Restaurant restaurant, DateTime date, String day) {
    dispatch(InitialiseEvent(restaurant: restaurant, date: date, day: day));
  }

  /// Dispatches a [NumberOfPeopleSelectedEvent]
  void numberOfPeopleSelected(int numberOfPeople) {
    dispatch(NumberOfPeopleSelectedEvent(numberOfPeople: numberOfPeople));
  }

  /// Dispatches a [TimeSelectedEvent]
  void timeSelected(String selectedTime) {
    dispatch(TimeSelectedEvent(selectedTime: selectedTime));
  }

  /// Dispatches a [BookNowPressedEvent]
  void bookNowPressed() {
    dispatch(BookNowPressedEvent());
  }

  /// Dispatches an [ErrorShownEvent]
  void errorShown() {
    dispatch(ErrorShownEvent());
  }

  /// Dispatches a [CardDetailsFlowStartedEvent]
  void cardDetailsFlowStarted() {
    dispatch(CardDetailsFlowStartedEvent());
  }

  /// Dispatches a [StopLoadingEvent]
  void stopLoading() {
    dispatch(StopLoadingEvent());
  }

  /// Dispatches a [CardDetailsEnteredEvent]
  void cardDetailsEntered(CardDetails cardDetails) {
    dispatch(CardDetailsEnteredEvent(cardDetails: cardDetails));
  }

  /// Dispatches a [TransactionCompleteEvent]
  void transactionComplete(Voucher voucher) {
    dispatch(TransactionCompleteEvent(voucher: voucher));
  }

  /// Dispatches a [TransactionFailedEvent]
  void transactionFailed(String error) {
    dispatch(TransactionFailedEvent(error: error));
  }

  /// Dispatches an [OrderConfirmedEvent]
  void orderConfirmed() {
    dispatch(OrderConfirmedEvent());
  }

  Future<void> _initSquarePayment(ConfigLoader configLoader) async {
    // Use the square app id from the config loader to initilise the square SDK
    await InAppPayments.setSquareApplicationId(configLoader['squareAppId']);
  }

  Future<void> _onStartCardEntryFlow() async {
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow);
  }

  ///
  /// Callback when card entry is cancelled and UI is closed
  ///
  void _onCancelCardEntryFlow() {
    // Handle the cancel callback
    stopLoading();
  }

  ///
  /// Callback when successfully get the card nonce details for processig
  /// card entry is still open and waiting for processing card nonce details
  ///
  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    try {
      // take payment with the card nonce details

      // payment finished successfully
      // you must call this method to close card entry
      InAppPayments.completeCardEntry(
          onCardEntryComplete: () => cardDetailsEntered(result));
    } catch (ex) {
      // payment failed to complete due to error
      // notify card entry to show processing error
      InAppPayments.showCardNonceProcessingError(ex.message);
    }
  }
}
