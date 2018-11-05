import 'package:flutter/material.dart';

/// The [Restaurant] class will be widely used throughout the app. It contains information that will
/// be used to display info about the restaurant on pages such as the find a restaurant page, map view,
/// restaurant profile page etc.
class Restaurant {
  /// Main display name of the restaurant.
  final String name;
  /// Typically a long text written by the restaurant to describe/advertise themself.
  final String description;
  

  Restaurant({@required this.name, @required this.description});
}