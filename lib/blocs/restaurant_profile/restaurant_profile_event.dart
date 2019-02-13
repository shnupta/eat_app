import 'package:flutter/material.dart';

import 'package:snacc/models.dart';

class RestaurantProfileEvent {}

class InitialiseEvent extends RestaurantProfileEvent {
  final Restaurant restaurant;

  InitialiseEvent({@required this.restaurant});
}

class DaySelectedEvent extends RestaurantProfileEvent {
  final String day;

  DaySelectedEvent({@required this.day});
}

class ClosePopupEvent extends RestaurantProfileEvent {}

class PreventPopupClosingEvent extends RestaurantProfileEvent {}

class AllowPopupClosingEvent extends RestaurantProfileEvent {}

class ToggleRestaurantFavouriteEvent extends RestaurantProfileEvent {}