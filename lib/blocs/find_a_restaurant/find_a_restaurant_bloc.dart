import 'package:snacc/blocs/find_a_restaurant/find_a_restaurant_event.dart';
import 'package:snacc/blocs/find_a_restaurant/find_a_restaurant_state.dart';

import 'package:snacc/models.dart';
import 'package:snacc/algolia/algolia_api.dart';

import 'package:snacc/database.dart';

import 'package:bloc/bloc.dart';

class FindARestaurantBloc
    extends Bloc<FindARestaurantEvent, FindARestaurantState> {

  FindARestaurantState get initialState {
    // Load the filter options on initialState unless they've already been loaded
      return FindARestaurantState.initialising();
  }

  @override
  Stream<FindARestaurantState> mapEventToState(
      FindARestaurantState state, FindARestaurantEvent event) async* {
    if (event is SearchEvent) {
      yield state.copyWith(isLoading: true, query: event.query);

      try {
        String _searchQuery = event.query ?? "";
        AlgoliaResponse response;
        if(state.facetFilters.length > 0 /*&& event.query.isNotEmpty*/)
          response = await state.index.search(event.query, state.facetFilters);
        else //if(event.query.isNotEmpty)
          response = await state.index.search(_searchQuery);
        //else 
        //  _results = List();

        if (response != null && !response.hasError) {
          List<Restaurant> results = response.hits
              .map((hit) => Restaurant.fromAlgoliaMap(hit))
              .toList();

          yield state.copyWith(results: results, query: event.query);
        }
      } catch (e) {
        yield FindARestaurantState.failure(e.message);
      }
    } else if (event is InitialiseEvent) {
      AlgoliaClient client = AlgoliaClient(
          appID: '1JUPZEJV71', searchKey: 'fdba16a946692e6ff2c30fc5d672203b');
      AlgoliaIndex index = client.initIndex('restaurants_search');

      List<Map<String, dynamic>> cats =
          await Database.readDocumentsAtCollection('category');
      List<Map<String, dynamic>> locs =
          await Database.readDocumentsAtCollection('location');
      Map<String, List<dynamic>> filterOptions = {
        'category': cats.map((c) {
          return {'name': c['name'], 'selected': false};
        }).toList(),
        'location': locs.map((l) {
          return {'name': l['name'], 'selected': false};
        }).toList()
      };

      Map<String, List<String>> facetFilters = Map();

      yield state.copyWith(
        isLoading: false,
        isInitialising: false,
        error: '',
        results: null,
        filterOptions: filterOptions,
        facetFilters: facetFilters,
        index: index,
        client: client,
      );
      search("");
    } else if (event is ClearResultsEvent) {
      yield state.copyWith(results: [], query: "");
    } else if (event is ToggleFilterMenuEvent) {
      if (state.filterMenuOpen == null) {
        yield state.copyWith(
            filterMenuOpen: true);
      }
      else {
        yield state.copyWith(
            filterMenuOpen: !state.filterMenuOpen,);
      }
    } else if (event is FilterItemSelectedEvent) {

      var _filterOptions = state.filterOptions;
      var _facetFilters = state.facetFilters;

      _filterOptions[event.type][event.index]['selected'] =
          !_filterOptions[event.type][event.index]['selected'];

      if(_filterOptions[event.type][event.index]['selected']) {
        if(_facetFilters['${event.type}'] == null) _facetFilters['${event.type}'] = List<String>();
        _facetFilters['${event.type}'].add('${_filterOptions[event.type][event.index]['name']}');
      } else { 
        _facetFilters['${event.type}'].remove('${_filterOptions[event.type][event.index]['name']}');
      }

      yield state.copyWith(
          filterMenuOpen: true,
          filterOptions: _filterOptions,
          facetFilters: _facetFilters);

      if(state.query != null) {
        search(state.query);
      }
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

  void filterOptionSelected(String type, int index) {
    dispatch(FilterItemSelectedEvent(type: type, index: index));
  }
}
