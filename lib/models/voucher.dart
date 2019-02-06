import 'package:snacc/models.dart';
import 'package:snacc/database.dart';

import 'package:flutter/material.dart';

class Voucher {
  /// Id of the voucher inside firebase
  String id;
  /// The user who purchased this voucher
  User user;
  /// The restaurant the voucher is for
  Restaurant restaurant;
  /// The number of people the voucher is booked for
  int numberOfPeople;
  /// The time the booking is for
  DateTime bookingTime;
  /// The time that the voucher was created
  DateTime createdAt;
  /// The day of the week that the booking is on
  String bookingDay;
  /// The generated card nonce from the Square SDK
  String cardNonce;
  /// The status of the transaction
  String status;
  /// The transaction Id returned from the Square Transactions API in the cloud function
  String transactionId;
  /// The time that the transaction was processed
  DateTime transactionTime;
  /// The discount this voucher provides
  int discount;

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
    @required this.discount,
  });

  /// Return the voucher as a map ready for writing to firebase
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
      'discount': discount,
    };
  }

  /// Construct a [Voucher] object from a map of data returned from a firebase snapshot
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
      discount: data['discount'],
    ));
  }

  /// Create a new voucher and write it to the database
  /// 
  /// This also triggers the cloud function that will start the payment processing.
  void createAndSaveToFirebase() {
    id = Database.createDocumentAtCollection('vouchers', toMap());
  }
}