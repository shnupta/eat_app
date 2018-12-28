import 'package:snacc/models.dart';

import 'package:snacc/algolia/algolia_api.dart';

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
  /// A Map of the filters to be used by the Algolia client
  final Map<String, List<String>> facetFilters;
  /// The Algolia search client
  final AlgoliaClient client;
  /// The Algolia index (of restaurants in this bloc's case)
  final AlgoliaIndex index;
  /// The current search query
  final String query;
  /// The currently selected available from time string
  final String availableFrom;
  /// The currently selected available to time string
  final String availableTo;
  /// Indicates whether to filter the restaurants based on the availability criteria
  final bool filterByAvailability;
  /// A Map of the selected days for the availability filter
  final Map<int, bool> availableFilterDays;

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
    this.availableFrom,
    this.availableTo,
    this.filterByAvailability,
    this.availableFilterDays,
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
  AlgoliaClient client, AlgoliaIndex index, Map<String, List<String>> facetFilters, String query,
  String availableTo, String availableFrom, bool filterByAvailability, Map<int, bool> availableFilterDays}) {
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
        availableFrom: availableFrom ?? this.availableFrom,
        availableTo: availableTo ?? this.availableTo,
        filterByAvailability: filterByAvailability ?? this.filterByAvailability,
        availableFilterDays: availableFilterDays ?? this.availableFilterDays,
		);
	}
}
