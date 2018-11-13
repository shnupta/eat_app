import 'package:flutter/material.dart';

import 'package:eat_app/models.dart';

class FindARestaurantState {
	/// Indicates whether a search is being performed
	final bool isLoading;
	/// Indicated whether the bloc is initialising
	final bool isInitialising;
	/// Will be populated with the error message if one has occurred.
	final String error;
	/// A list of restaurants that are returned as matching the search criteria by Algolia
	final List<Restaurant> results;

	FindARestaurantState({
		@required this.isLoading,
		@required this.isInitialising,
		@required this.error,
		@required this.results,
	});


	factory FindARestaurantState.initialising() {
		return FindARestaurantState(
				isLoading: false,
				isInitialising: true,
				error: '',
				results: null,
		);
	}

	factory FindARestaurantState.loading() {
		return FindARestaurantState(
				isInitialising: false,
				isLoading: true,
				error: '',
				results: null,
		);
	}

	factory FindARestaurantState.displaying(List<Restaurant> restaurants) {
		return FindARestaurantState(
				isLoading: false,
				isInitialising: false,
				error: '',
				results: restaurants,
		);
	}

	factory FindARestaurantState.failure(String error) {
		return FindARestaurantState(
				isInitialising: false,
				isLoading: false,
				results: null,
				error: error,
		);
	}

	FindARestaurantState copyWith({bool isLoading, bool isInitialising, String error, List<Restaurant> results}) {
		return FindARestaurantState(
				isLoading: isLoading ?? this.isLoading,
				isInitialising: isInitialising ?? this.isInitialising,
				error: error ?? this.error,
				results: results ?? this.results,
		);
	}
}
