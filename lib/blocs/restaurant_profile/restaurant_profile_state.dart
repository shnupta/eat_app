import 'package:snacc/models.dart';

import 'package:flutter/material.dart';

class RestaurantProfileState {
  /// The current restaurant whose profile is being views
  final Restaurant restaurant;
  /// Whether the bloc is initialising or not
  final bool isInitialising;
  /// Should the booking popup be visible
  final bool showDayBookingPopup;
  /// The selected day to book
  final String selectedDay;
  /// Whether the user can close the booking popup
  final bool canClosePopup;

  RestaurantProfileState({@required this.restaurant, this.isInitialising, this.showDayBookingPopup,
  this.selectedDay, this.canClosePopup});

  factory RestaurantProfileState.initialising() => RestaurantProfileState(
    restaurant: null,
    isInitialising: true,
    showDayBookingPopup: false,
    canClosePopup: true,
  );

  RestaurantProfileState copyWith({Restaurant restaurant, bool isInitialising, bool showDayBookingPopup,
  String selectedDay, bool canClosePopup}) {
    return RestaurantProfileState(
      restaurant: restaurant ?? this.restaurant,
      isInitialising: isInitialising ?? this.isInitialising,
      showDayBookingPopup: showDayBookingPopup ?? this.showDayBookingPopup,
      selectedDay: selectedDay ?? this.selectedDay,
      canClosePopup: canClosePopup ?? this.canClosePopup,
    );
  }
}