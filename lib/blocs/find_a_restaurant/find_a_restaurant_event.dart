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

/// Dispatch this event when a user selects a filter option
class FilterItemSelectedEvent extends FindARestaurantEvent {
  final String type;
  final int index;

  FilterItemSelectedEvent({@required this.type, @required this.index});
}

/// Dispatch this event when the user changes the availability 'to' date
class AvailbleToSelectedEvent extends FindARestaurantEvent {
  final String time;

  AvailbleToSelectedEvent({@required this.time});
}

/// Dispatch this event when the user changes the availability 'from' date
class AvailbleFromSelectedEvent extends FindARestaurantEvent {
  final String time;

  AvailbleFromSelectedEvent({@required this.time});
}

/// Dispatch this event when the user toggles the checkbox to indicate they would like to filter by availability
class ToggleFilterByAvailabilityEvent extends FindARestaurantEvent {}

/// Dispatch this event when the user selected or deselects a day of the week from the availability filter
/// section.
class AvailableDaySelectedEvent extends FindARestaurantEvent {
  final int index;

  AvailableDaySelectedEvent({@required this.index});
}

class OrderBySelectedEvent extends FindARestaurantEvent {
  final String type;

  OrderBySelectedEvent({@required this.type});
}