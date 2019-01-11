import 'package:snacc/models.dart';
import 'package:snacc/database.dart';

import 'package:flutter/material.dart';

class Voucher {
  String id;
  User user;
  Restaurant restaurant;
  int numberOfPeople;
  DateTime bookingTime;
  DateTime createdAt;
  String bookingDay;
  String cardNonce;
  String status;
  String transactionId;
  DateTime transactionTime;

  static const String STATUS_CREATED = 'created';
  static const String STATUS_TRANSACTION_COMPLETE = 'transaction_complete';
  static const String STATUS_TRANSACTION_FAILED = 'transaction_failed';
  

  Voucher({
    this.id,
    @required this.user,
    @required this.restaurant,
    @required this.numberOfPeople,
    @required this.bookingTime,
    @required this.createdAt,
    @required this.cardNonce,
    this.status = STATUS_CREATED,
    this.transactionTime,
    this.transactionId,
    this.bookingDay,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': user.id,
      'restaurantId': restaurant.id,
      'numberOfPeople': numberOfPeople,
      'bookingTime': bookingTime,
      'cardNonce': cardNonce,
      'status': status,
      'createdAt': createdAt,
      'bookingDay': bookingDay,
    };
  }

  static Future<Voucher> fromFirebase(Map<String, dynamic> data) async {
    return Future.value(
      Voucher(
      createdAt: data['createdAt'],
      numberOfPeople: data['numberOfPeople'],
      cardNonce: data['cardNonce'],
      user: await User.fromId(data['userId']),
      bookingTime: data['bookingTime'],
      restaurant: await Restaurant.fromId(data['restaurantId']),
      transactionId: data['transactionId'],
      id: data['id'],
      bookingDay: data['bookingDay'],
    ));
  }

  void createAndSaveToFirebase() {
    id = Database.createDocumentAtCollection('vouchers', toMap());
  }
}