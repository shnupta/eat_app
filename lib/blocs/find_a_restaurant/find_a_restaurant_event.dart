import 'package:flutter/material.dart';


abstract class FindARestaurantEvent {}

/// This event is first sent to the bloc in order to initialise variables such as the connection to Algolia
class InitialiseEvent extends FindARestaurantEvent {}

/// Dispatch this event when you want to search the Algolia index to return restaurants that match the search criteria
class SearchEvent extends FindARestaurantEvent {
	/// The query string the user types in.
	final String query;

	SearchEvent({@required this.query});
}

/// Dispatch this event when the search query is empty, it will clear the array of
/// results inside the bloc.
class ClearResultsEvent extends FindARestaurantEvent {}

/// Dispatch this event when the user clicks on the button to expand the filter menu.
class ToggleFilterMenuEvent extends FindARestaurantEvent {}
