import 'package:bloc/bloc.dart';

import 'package:snacc/blocs/booking/booking_event.dart';
import 'package:snacc/blocs/booking/booking_state.dart';

import 'package:snacc/models.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingState get initialState => BookingState.initialising();

  @override
  Stream<BookingState> mapEventToState(
      BookingState state, BookingEvent event) async* {
    if (event is InitialiseEvent) {
      yield BookingState(
          restaurant: event.restaurant,
          date: event.date,
          day: event.day,
          isInitialising: false,
          numberOfPeople: 2);
    } else if (event is NumberOfPeopleSelectedEvent) {
      yield state.copyWith(numberOfPeople: event.numberOfPeople);
    }
  }

  void initialise(Restaurant restaurant, DateTime date, String day) {
    dispatch(InitialiseEvent(restaurant: restaurant, date: date, day: day));
  }

  void numberOfPeopleSelected(int numberOfPeople) {
    dispatch(NumberOfPeopleSelectedEvent(numberOfPeople: numberOfPeople));
  }
}
