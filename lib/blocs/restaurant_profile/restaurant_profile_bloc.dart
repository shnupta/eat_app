import 'package:bloc/bloc.dart';

import 'package:snacc/blocs/restaurant_profile/restaurant_profile_event.dart';
import 'package:snacc/blocs/restaurant_profile/restaurant_profile_state.dart';

import 'package:snacc/models.dart';

class RestaurantProfileBloc
    extends Bloc<RestaurantProfileEvent, RestaurantProfileState> {
  RestaurantProfileState get initialState => RestaurantProfileState.initialising();

  @override
  Stream<RestaurantProfileState> mapEventToState(
      RestaurantProfileState state, RestaurantProfileEvent event) async* {
    if(event is InitialiseEvent) {
      yield RestaurantProfileState(restaurant: event.restaurant, isInitialising: false);
    } else if(event is DaySelectedEvent) {
      yield state.copyWith(showDayBookingPopup: true, selectedDay: event.day);
    } else if(event is ClosePopupEvent) {
      yield state.copyWith(showDayBookingPopup: false, selectedDay: null);
    }
  }

  /// Dispatches an [InitialiseEvent]
  void initialise(Restaurant restaurant) {
    dispatch(InitialiseEvent(restaurant: restaurant));
  }

  /// Dispatches a [DaySelectedEvent]
  void selectDay(String day) {
    dispatch(DaySelectedEvent(day: day));
  }

  void closePopup() {
    dispatch(ClosePopupEvent());
  }
}
