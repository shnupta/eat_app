import 'package:snacc/models.dart';

import 'package:flutter/material.dart';

class RestaurantProfileState {
  final Restaurant restaurant;
  final bool isInitialising;
  final bool showDayBookingPopup;
  final String selectedDay;
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