import 'package:snacc/models.dart';

import 'package:flutter/material.dart';

class BookingState {
  final Restaurant restaurant;
  final DateTime date;
  final String day;
  final bool isInitialising;
  final int numberOfPeople;

  BookingState(
      {@required this.restaurant, @required this.date, @required this.day, this.isInitialising, this.numberOfPeople});

  factory BookingState.initialising() => BookingState(
    restaurant: null,
    date: null,
    day: null,
    isInitialising: true,
    numberOfPeople: null,
  );

  BookingState copyWith({Restaurant restaurant, DateTime date, String day, bool isInitialising,
  int numberOfPeople}) {
    return BookingState(
      restaurant: restaurant ?? this.restaurant,
      date: date ?? this.date,
      day: day ?? this.day,
      isInitialising: isInitialising ?? this.isInitialising,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
    );
  }
}
