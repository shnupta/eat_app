import 'package:eat_app/blocs/find_a_restaurant/find_a_restaurant_event.dart';
import 'package:eat_app/blocs/find_a_restaurant/find_a_restaurant_state.dart';

import 'package:eat_app/models.dart';
import 'package:eat_app/database.dart';
import 'package:eat_app/algolia/algolia_api.dart';

import 'package:bloc/bloc.dart';

import 'dart:convert';


class FindARestaurantBloc extends Bloc<FindARestaurantEvent, FindARestaurantState> {
	List<Restaurant> _results;
	AlgoliaClient _client; 	
	AlgoliaIndex _index; 


	FindARestaurantState get initialState {
		if(_results != null) {
			return FindARestaurantState(
					results: _results,
					isLoading: false,
					isInitialising: false,
					error: '',
			);
		}	else {
			return FindARestaurantState.initialising();
		}
	}

	@override
	Stream<FindARestaurantState> mapEventToState(FindARestaurantState state, FindARestaurantEvent event) async* {
		if(event is SearchEvent) {
			yield FindARestaurantState.loading();

			try {
				final response = await _index.search(event.query);
				if(!response.hasError) {
					//_results = json.decode(response.body);
					print(json.encode(response.body));
					yield FindARestaurantState.displaying(null);
				}
			} catch(e) {
				yield FindARestaurantState.failure(e.message);
			}
		} else if(event is InitialiseEvent) {
			_client = AlgoliaClient(appID: '1JUPZEJV71', searchKey: 'fdba16a946692e6ff2c30fc5d672203b');
			_index = _client.initIndex('restaurants_search');

			yield FindARestaurantState.displaying(null);
		}
	}


	void search(String query) {
		dispatch(SearchEvent(query: query));
	}

	void initialise() {
		dispatch(InitialiseEvent());
	}

}
