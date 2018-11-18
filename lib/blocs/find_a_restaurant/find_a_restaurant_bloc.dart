import 'package:eat_app/blocs/find_a_restaurant/find_a_restaurant_event.dart';
import 'package:eat_app/blocs/find_a_restaurant/find_a_restaurant_state.dart';

import 'package:eat_app/models.dart';
import 'package:eat_app/algolia/algolia_api.dart';

import 'package:eat_app/database.dart';

import 'package:bloc/bloc.dart';


class FindARestaurantBloc extends Bloc<FindARestaurantEvent, FindARestaurantState> {
	List<Restaurant> _results;
	Map<String, List<dynamic>> _filterOptions;
	AlgoliaClient _client; 	
	AlgoliaIndex _index; 


	FindARestaurantState get initialState {
		// Load the filter options on initialState unless they've already been loaded
		if(_results != null && _filterOptions != null) {
			return FindARestaurantState(
					results: _results,
					isLoading: false,
					isInitialising: false,
					error: '',
					filterOptions: _filterOptions,
			);
		}	else {
			return FindARestaurantState.initialising();
		}
	}

	@override
	Stream<FindARestaurantState> mapEventToState(FindARestaurantState state, FindARestaurantEvent event) async* {
		if(event is SearchEvent) {
			yield state.copyWith(isLoading: true, results: _results);

			try {
				final response = await _index.search(event.query);
				if(!response.hasError) {
					_results = response.hits.map((hit) => Restaurant.fromAlgoliaMap(hit)).toList();

					yield FindARestaurantState.displaying(_results);
				}
			} catch(e) {
				yield FindARestaurantState.failure(e.message);
			}
		} else if(event is InitialiseEvent) {
			_client = AlgoliaClient(appID: '1JUPZEJV71', searchKey: 'fdba16a946692e6ff2c30fc5d672203b');
			_index = _client.initIndex('restaurants_search');

			List<Map<String,dynamic>> cats = await Database.readDocumentsAtCollection('categories');
			_filterOptions = {
				'categories': cats
			};

			yield FindARestaurantState(
				isLoading: false,
				isInitialising: false,
				error: '',
				results: null,
				filterOptions: _filterOptions,
			);
		} else if(event is ClearResultsEvent) {
			yield state.copyWith(results: null); 
		} else if(event is ToggleFilterMenuEvent) {
			if(state.filterMenuOpen == null) 
				yield state.copyWith(filterMenuOpen: true, results: _results, filterOptions: _filterOptions);
				else yield state.copyWith(filterMenuOpen: !state.filterMenuOpen, results: _results, filterOptions: _filterOptions);
		}
	}


	/// Dispatch a search event with [query] as the search string
	void search(String query) {
		dispatch(SearchEvent(query: query));
	}

	/// Dispatch an event to make the bloc initialise itself
	void initialise() {
		dispatch(InitialiseEvent());
	}

	/// Dispatch a ClearResultsEvent to wipe the results list
	void clearResults() {
		dispatch(ClearResultsEvent());
	}

	/// Dispatches an ToggleFilterMenuEvent
	void toggleFilterMenu() {
		dispatch(ToggleFilterMenuEvent());
	}

}
