import 'package:bloc/bloc.dart';

import 'package:snacc/blocs/restaurant_profile/restaurant_profile_event.dart';
import 'package:snacc/blocs/restaurant_profile/restaurant_profile_state.dart';

import 'package:snacc/models.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RestaurantProfileBloc
    extends Bloc<RestaurantProfileEvent, RestaurantProfileState> {
  RestaurantProfileState get initialState =>
      RestaurantProfileState.initialising();

  @override
  Stream<RestaurantProfileState> mapEventToState(
      RestaurantProfileState state, RestaurantProfileEvent event) async* {
    if (event is InitialiseEvent) {
      User user =
          User.fromFirebaseUser(await FirebaseAuth.instance.currentUser());
      List<String> favourites = await user.getFavouriteRestaurants();
      yield RestaurantProfileState(
          restaurant: event.restaurant,
          isInitialising: false,
          isRestaurantUserFavourite: favourites.contains(event.restaurant.id));
    } else if (event is DaySelectedEvent) {
      yield state.copyWith(showDayBookingPopup: true, selectedDay: event.day);
    } else if (event is ClosePopupEvent) {
      if (state.canClosePopup) {
        // Prevent the backgroung popup from being closed (done when loading stuff)
        yield state.copyWith(
            showDayBookingPopup: false, selectedDay: null, canClosePopup: true);
      } else {
        yield state;
      }
    } else if (event is PreventPopupClosingEvent) {
      yield state.copyWith(canClosePopup: false);
    } else if (event is AllowPopupClosingEvent) {
      yield state.copyWith(canClosePopup: true);
    } else if(event is ToggleRestaurantFavouriteEvent) {
      User user =
          User.fromFirebaseUser(await FirebaseAuth.instance.currentUser());
      user.toggleFavouriteRestaurant(state.restaurant);
      yield state.copyWith(isRestaurantUserFavourite: !state.isRestaurantUserFavourite);
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

  /// Dispatches a [ClosePopupEvent]
  void closePopup() {
    dispatch(ClosePopupEvent());
  }

  /// Dispatches a [PreventPopupClosingEvent]
  void preventPopupClosing() {
    dispatch(PreventPopupClosingEvent());
  }

  /// Dispatches an [AllowPopupClosingEvent]
  void allowPopupClosing() {
    dispatch(AllowPopupClosingEvent());
  }

  void toggleFavourite() {
    dispatch(ToggleRestaurantFavouriteEvent());
  }
}
