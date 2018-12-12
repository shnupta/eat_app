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
  /// URL of the restaurant's logo image
  final String logoUrl;
  

  Restaurant({@required this.id, @required this.name, @required this.description, @required this.logoUrl});


	/// Constructs a [Restaurant] object from a hit object of an Algolia search response
	factory Restaurant.fromAlgoliaMap(Map<String, dynamic> map) {
		return Restaurant(
				id: map['objectID'],
				name: map['name'],
				description: map['description'],
        logoUrl: map['logoUrl'] ?? "https://firebasestorage.googleapis.com/v0/b/eat-app-d60bf.appspot.com/o/restaurant_logos%2Fzizi%20logo.png?alt=media&token=48874367-a048-4e2a-9ba7-6fc347fcc62b"
		);
	}
}
