import 'package:snacc/models.dart';

import 'package:flutter/material.dart';

class RestaurantProfileState {
  final Restaurant restaurant;
  final bool isInitialising;
  final bool showDayBookingPopup;
  final String selectedDay;

  RestaurantProfileState({@required this.restaurant, this.isInitialising, this.showDayBookingPopup,
  this.selectedDay});

  factory RestaurantProfileState.initialising() => RestaurantProfileState(
    restaurant: null,
    isInitialising: true,
    showDayBookingPopup: false,
  );

  RestaurantProfileState copyWith({Restaurant restaurant, bool isInitialising, bool showDayBookingPopup,
  String selectedDay}) {
    return RestaurantProfileState(
      restaurant: restaurant ?? this.restaurant,
      isInitialising: isInitialising ?? this.isInitialising,
      showDayBookingPopup: showDayBookingPopup ?? this.showDayBookingPopup,
      selectedDay: selectedDay ?? this.selectedDay,
    );
  }
}