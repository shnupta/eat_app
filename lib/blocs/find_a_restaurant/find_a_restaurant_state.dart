import 'package:flutter/material.dart';

import 'package:eat_app/models.dart';

import 'package:eat_app/algolia/algolia_api.dart';

class FindARestaurantState {
	/// Indicates whether a search is being performed
	final bool isLoading;
	/// Indicated whether the bloc is initialising
	final bool isInitialising;
	/// Will be populated with the error message if one has occurred.
	final String error;
	/// A list of restaurants that are returned as matching the search criteria by Algolia
	final List<Restaurant> results;
	/// Indicates whether the filter menu should be open
	final bool filterMenuOpen;
	/// A Map of the filter options available
	final Map<String, List<dynamic>> filterOptions;
  final Map<String, List<String>> facetFilters;
  final AlgoliaClient client;
  final AlgoliaIndex index;
  final String query;

	FindARestaurantState({
		this.isLoading,
		this.isInitialising,
		this.error,
		this.results,
		this.filterMenuOpen,
		this.filterOptions,
    this.client,
    this.facetFilters,
    this.index,
    this.query,
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

	factory FindARestaurantState.displaying(List<Restaurant> restaurants, bool filterMenuOpen, Map<String, List<dynamic>> filterOptions) {
		return FindARestaurantState(
				isLoading: false,
				isInitialising: false,
				error: '',
				results: restaurants,
        filterMenuOpen: filterMenuOpen,
        filterOptions: filterOptions,
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

	FindARestaurantState copyWith({bool isLoading, bool isInitialising, String error, 
  List<Restaurant> results, bool filterMenuOpen, Map<String, List<dynamic>> filterOptions,
  AlgoliaClient client, AlgoliaIndex index, Map<String, List<String>> facetFilters, String query}) {
		return FindARestaurantState(
				isLoading: isLoading ?? this.isLoading,
				isInitialising: isInitialising ?? this.isInitialising,
				error: error ?? this.error,
				results: results ?? this.results,
				filterMenuOpen: filterMenuOpen ?? this.filterMenuOpen,
				filterOptions: filterOptions ?? this.filterOptions,
        facetFilters: facetFilters ?? this.facetFilters,
        index: index ?? this.index,
        client: client ?? this.client,
        query: query ?? this.query,
		);
	}
}
