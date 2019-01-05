import 'package:snacc/models.dart';

import 'package:flutter/material.dart';

class BookingState {
  final Restaurant restaurant;
  final DateTime date;
  final String day;
  final String selectedTime;
  final bool isInitialising;
  final int numberOfPeople;
  final String error;
  final bool isLoading;
  final User user;
  final bool needsToEnterCardDetails;
  final bool finished;

  BookingState(
      {@required this.restaurant, @required this.date, @required this.day, this.isInitialising, 
      this.numberOfPeople, this.selectedTime, this.error, this.isLoading, this.user,
      this.needsToEnterCardDetails, this.finished});

  factory BookingState.initialising() => BookingState(
    restaurant: null,
    date: null,
    day: null,
    isInitialising: true,
    isLoading: false,
    finished: false,
  );

  BookingState copyWith({Restaurant restaurant, DateTime date, String day, bool isInitialising,
  int numberOfPeople, String selectedTime, String error, bool isLoading, User user,
  bool needsToEnterCardDetails, bool finished}) {
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
      needsToEnterCardDetails: needsToEnterCardDetails ?? this.needsToEnterCardDetails,
      finished: finished ?? this.finished,
    );
  }
}
