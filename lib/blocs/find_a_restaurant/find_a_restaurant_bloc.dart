import 'package:eat_app/blocs/find_a_restaurant/find_a_restaurant_event.dart';
import 'package:eat_app/blocs/find_a_restaurant/find_a_restaurant_state.dart';

import 'package:eat_app/models.dart';
import 'package:eat_app/algolia/algolia_api.dart';

import 'package:eat_app/database.dart';

import 'package:bloc/bloc.dart';

class FindARestaurantBloc
    extends Bloc<FindARestaurantEvent, FindARestaurantState> {
  List<Restaurant> _results;
  Map<String, List<dynamic>> _filterOptions;
  Map<String, List<String>> _facetFilters;
  AlgoliaClient _client;
  AlgoliaIndex _index;
  String _searchQuery;
  bool _filterMenuOpen;

  FindARestaurantState get initialState {
    // Load the filter options on initialState unless they've already been loaded
    if (_results != null && _filterOptions != null) {
      return FindARestaurantState(
        results: _results,
        isLoading: false,
        isInitialising: false,
        error: '',
        filterOptions: _filterOptions,
        filterMenuOpen: _filterMenuOpen,
      );
    } else {
      return FindARestaurantState.initialising();
    }
  }

  @override
  Stream<FindARestaurantState> mapEventToState(
      FindARestaurantState state, FindARestaurantEvent event) async* {
    if (event is SearchEvent) {
      yield state.copyWith(isLoading: true, results: _results, filterMenuOpen: state.filterMenuOpen, filterOptions: _filterOptions);

      try {
        _searchQuery = event.query;
        AlgoliaResponse response;
        if(_facetFilters.length > 0 && event.query.isNotEmpty)
          response = await _index.search(event.query, _facetFilters);
        else if(event.query.isNotEmpty)
          response = await _index.search(event.query);
        else 
          _results = List();

        if (response != null && !response.hasError) {
          _results = response.hits
              .map((hit) => Restaurant.fromAlgoliaMap(hit))
              .toList();

          yield FindARestaurantState.displaying(_results, state.filterMenuOpen, state.filterOptions);
        }
      } catch (e) {
        yield FindARestaurantState.failure(e.message);
      }
    } else if (event is InitialiseEvent) {
      _client = AlgoliaClient(
          appID: '1JUPZEJV71', searchKey: 'fdba16a946692e6ff2c30fc5d672203b');
      _index = _client.initIndex('restaurants_search');

      List<Map<String, dynamic>> cats =
          await Database.readDocumentsAtCollection('category');
      List<Map<String, dynamic>> locs =
          await Database.readDocumentsAtCollection('location');
      _filterOptions = {
        'category': cats.map((c) {
          return {'name': c['name'], 'selected': false};
        }).toList(),
        'location': locs.map((l) {
          return {'name': l['name'], 'selected': false};
        }).toList()
      };

      _facetFilters = Map();

      yield FindARestaurantState(
        isLoading: false,
        isInitialising: false,
        error: '',
        results: null,
        filterOptions: _filterOptions,
      );
    } else if (event is ClearResultsEvent) {
      _searchQuery = '';
      _results = null;
      yield state.copyWith(results: null);
    } else if (event is ToggleFilterMenuEvent) {
      if (state.filterMenuOpen == null) {
        _filterMenuOpen = true;
        yield state.copyWith(
            filterMenuOpen: true,
            results: _results,
            filterOptions: _filterOptions);
      }
      else {
        _filterMenuOpen = !_filterMenuOpen;
        yield state.copyWith(
            filterMenuOpen: !state.filterMenuOpen,
            results: _results,
            filterOptions: _filterOptions);
      }
    } else if (event is FilterItemSelectedEvent) {
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
          results: _results,
          filterOptions: _filterOptions);

      if(_searchQuery != null) {
        dispatch(SearchEvent(query: _searchQuery));
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
