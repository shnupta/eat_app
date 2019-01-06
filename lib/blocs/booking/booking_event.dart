import 'package:flutter/material.dart';

import 'package:snacc/models.dart';

import 'package:square_in_app_payments/models.dart';

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

class TimeSelectedEvent extends BookingEvent {
  String selectedTime;

  TimeSelectedEvent({@required this.selectedTime});
}

class BookNowPressedEvent extends BookingEvent {}

class ErrorShownEvent extends BookingEvent {}

class CardDetailsFlowStartedEvent extends BookingEvent {}

class StopLoadingEvent extends BookingEvent {}

class ErrorEvent extends BookingEvent {
  String message;

  ErrorEvent({@required this.message});
}

class CardDetailsEnteredEvent extends BookingEvent {
  CardDetails cardDetails;

  CardDetailsEnteredEvent({@required this.cardDetails});
}

class TransactionCompleteEvent extends BookingEvent {
  Voucher voucher;

  TransactionCompleteEvent({@required this.voucher});
}

class OrderConfirmedEvent extends BookingEvent {}

class TransactionFailedEvent extends BookingEvent {
  String error;

  TransactionFailedEvent({@required this.error});
}