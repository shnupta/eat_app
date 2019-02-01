import 'package:snacc/models.dart';

import 'package:square_in_app_payments/models.dart';

import 'package:flutter/material.dart';

class BookingState {
  /// The restaurant currently being possibly booked
  final Restaurant restaurant;
  /// The date of booking
  final DateTime date;
  /// The day of the week of the booking
  final String day;
  /// The selected time that the user would like to book
  final String selectedTime;
  /// Is the bloc initialising
  final bool isInitialising;
  /// The number of people to book a voucher for
  final int numberOfPeople;
  /// The string of the current error
  final String error;
  /// Is the bloc loading
  final bool isLoading;
  /// The current user logged into the app, making the booking
  final User user;
  /// If the user needs to enter their card details
  final bool needsToEnterCardDetails;
  /// Has the booking dialog flow finished
  final bool finished;
  /// Whether to show the booking confirmation
  final bool showConfirmation;
  /// The card details entered by the user
  final CardDetails cardDetails;
  /// Whether to show the voucher purchase receipt
  final bool showReceipt;
  /// The voucher related to the booking
  final Voucher voucher;
  /// Whether to show the transaction error
  final bool showTransactionError;
  /// The transaction error
  final String transactionError;

  BookingState({
    @required this.restaurant,
    @required this.date,
    @required this.day,
    this.isInitialising,
    this.numberOfPeople,
    this.selectedTime,
    this.error,
    this.isLoading,
    this.user,
    this.needsToEnterCardDetails,
    this.finished,
    this.showConfirmation,
    this.cardDetails,
    this.showReceipt,
    this.voucher,
    this.showTransactionError,
    this.transactionError,
  });

  factory BookingState.initialising() => BookingState(
        restaurant: null,
        date: null,
        day: null,
        isInitialising: true,
        isLoading: false,
        finished: false,
        showConfirmation: false,
        showReceipt: false,
        showTransactionError: false,
      );

  BookingState copyWith({
    Restaurant restaurant,
    DateTime date,
    String day,
    bool isInitialising,
    int numberOfPeople,
    String selectedTime,
    String error,
    bool isLoading,
    User user,
    bool needsToEnterCardDetails,
    bool finished,
    bool showConfirmation,
    CardDetails cardDetails,
    bool showReceipt,
    Voucher voucher,
    bool showTransactionError,
    String transactionError,
  }) {
    return BookingState(
      restaurant: restaurant ?? this.restaurant,
      date: date ?? this.date,
      day: day ?? this.day,
      isInitialising: isInitialising ?? this.isInitialising,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      selectedTime: selectedTime ?? this.selectedTime,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      needsToEnterCardDetails:
          needsToEnterCardDetails ?? this.needsToEnterCardDetails,
      finished: finished ?? this.finished,
      showConfirmation: showConfirmation ?? this.showConfirmation,
      cardDetails: cardDetails ?? this.cardDetails,
      showReceipt: showReceipt ?? this.showReceipt,
      voucher: voucher ?? this.voucher,
      showTransactionError: showTransactionError ?? this.showTransactionError,
      transactionError: transactionError ?? this.transactionError,
    );
  }
}
