import 'package:flutter/material.dart';

import 'package:snacc/models.dart';

class BookingEvent {}

class InitialiseEvent extends BookingEvent {
  final Restaurant restaurant;
  final DateTime date;
  final String day;

  InitialiseEvent({@required this.restaurant, @required this.date, @required this.day});
}

class NumberOfPeopleSelectedEvent extends BookingEvent {
  final int numberOfPeople;

  NumberOfPeopleSelectedEvent({@required this.numberOfPeople});
}