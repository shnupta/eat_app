import 'package:flutter/material.dart';

/// The [Restaurant] class will be widely used throughout the app. It contains information that will
/// be used to display info about the restaurant on pages such as the find a restaurant page, map view,
/// restaurant profile page etc.
class Restaurant {
  /// Main display name of the restaurant.
  final String name;
  /// Typically a long text written by the restaurant to describe/advertise themself.
  final String description;
	/// ID of the object in firebase
	final String id;
  

  Restaurant({@required this.id, @required this.name, @required this.description});


	/// Constructs a [Restaurant] object from a hit object of an Algolia search response
	factory Restaurant.fromAlgoliaMap(Map<String, dynamic> map) {
		return Restaurant(
				id: map['objectID'],
				name: map['name'],
				description: map['description'],
		);
	}
}
