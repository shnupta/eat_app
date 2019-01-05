import 'package:snacc/models.dart';
import 'package:snacc/database.dart';

import 'package:flutter/material.dart';

class Voucher {
  String id;
  User user;
  Restaurant restaurant;
  int numberOfPeople;
  DateTime datetime;
  String cardNonce;
  String status;
  

  Voucher({
    this.id,
    @required this.user,
    @required this.restaurant,
    @required this.numberOfPeople,
    @required this.datetime,
    @required this.cardNonce,
    this.status = 'created',
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': user.id,
      'restaurantId': restaurant.id,
      'numberOfPeople': numberOfPeople,
      'datetime': datetime,
      'cardNonce': cardNonce,
      'status': status,
    };
  }

  void createAndSaveToFirebase() {
    id = Database.createDocumentAtCollection('vouchers', toMap());
  }
}