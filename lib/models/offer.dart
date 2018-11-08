import 'package:flutter/material.dart';

import 'package:eat_app/models.dart';

/// An [Offer] is a type of [Article] that represents a current deal that a restaurant or the app has
/// available.
class Offer extends Article {
  /// The restaurant that has the offer on.
  final Restaurant restaurant;

  Offer(
      {@required title,
      @required body,
      @required timestamp,
      @required this.restaurant,
      @required id})
      : super(title: title, body: body, timestamp: timestamp, id: id,);
}
