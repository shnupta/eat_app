import 'package:snacc/blocs/find_a_restaurant/find_a_restaurant_event.dart';
import 'package:snacc/blocs/find_a_restaurant/find_a_restaurant_state.dart';

import 'package:snacc/models.dart';
import 'package:snacc/algolia/algolia_api.dart';

import 'package:snacc/database.dart';

import 'package:bloc/bloc.dart';

import 'package:location/location.dart';

import 'dart:math';

import 'package:tuple/tuple.dart';

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
        if (state.facetFilters.length > 0 /*&& event.query.isNotEmpty*/)
          response = await state.index.search(event.query, state.facetFilters);
        else //if(event.query.isNotEmpty)
          response = await state.index.search(_searchQuery);
        //else
        //  _results = List();

        if (response != null && !response.hasError) {
          List<Restaurant> results = response.hits
              .map((hit) => Restaurant.fromAlgoliaMap(hit))
              .toList();

          if (results.isNotEmpty) {
            if (state.filterByAvailability) {
              results = results
                  .where((restaurant) => isInsideAvailability(
                      restaurant,
                      state.availableFrom,
                      state.availableTo,
                      state.availableFilterDays))
                  .toList();
            }

            if (state.orderBy['distance']) {
              // Get user's location
              Location userLocation = new Location();
              Map<String, double> loc = Map();
              try {
                loc = await userLocation.getLocation();
              } catch (e) {
                print('error');
              }

              List<Tuple2> distances = List();
              results.forEach((restaurant) {
                double dist = distanceInMiles(
                    loc['latitude'],
                    loc['longitude'],
                    restaurant.latLong['latitude'],
                    restaurant.latLong['longitude']);
                distances.add(Tuple2(restaurant, dist));
              });
              results = sortByDistance(
                  distances); // order the results in ascending distance order
            }
          }

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
      Map<int, bool> availableDaysFilters = {
        0: false,
        1: false,
        2: false,
        3: false,
        4: false,
        5: false,
        6: false
      };

      Map<String, bool> orderBy = {
        'relevance': true,
        'popularity': false,
        'distance': false,
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
        filterByAvailability: false,
        availableFrom: "0:00",
        availableTo: "0:00",
        availableFilterDays: availableDaysFilters,
        orderBy: orderBy,
      );
      search("");
    } else if (event is ClearResultsEvent) {
      yield state.copyWith(results: [], query: "");
    } else if (event is ToggleFilterMenuEvent) {
      if (state.filterMenuOpen == null) {
        yield state.copyWith(filterMenuOpen: true);
      } else {
        yield state.copyWith(
          filterMenuOpen: !state.filterMenuOpen,
        );
      }
    } else if (event is FilterItemSelectedEvent) {
      var _filterOptions = state.filterOptions;
      var _facetFilters = state.facetFilters;

      _filterOptions[event.type][event.index]['selected'] =
          !_filterOptions[event.type][event.index]['selected'];

      if (_filterOptions[event.type][event.index]['selected']) {
        if (_facetFilters['${event.type}'] == null)
          _facetFilters['${event.type}'] = List<String>();
        _facetFilters['${event.type}']
            .add('${_filterOptions[event.type][event.index]['name']}');
      } else {
        _facetFilters['${event.type}']
            .remove('${_filterOptions[event.type][event.index]['name']}');
      }

      yield state.copyWith(
          filterMenuOpen: true,
          filterOptions: _filterOptions,
          facetFilters: _facetFilters);

      if (state.query != null) {
        search(state.query);
      }
    } else if (event is AvailbleFromSelectedEvent) {
      yield state.copyWith(availableFrom: event.time);
      search(state.query);
    } else if (event is AvailbleToSelectedEvent) {
      yield state.copyWith(availableTo: event.time);
      search(state.query);
    } else if (event is ToggleFilterByAvailabilityEvent) {
      yield state.copyWith(filterByAvailability: !state.filterByAvailability);
      search(state.query);
    } else if (event is AvailableDaySelectedEvent) {
      Map<int, bool> days = state.availableFilterDays;
      days[event.index] = !days[event.index];
      yield state.copyWith(availableFilterDays: days);
      search(state.query);
    } else if (event is OrderBySelectedEvent) {
      Map<String, bool> orderBy = state.orderBy;
      orderBy.forEach((String type, bool val) => orderBy[type] = false);
      orderBy[event.type] = true;
      state.copyWith(orderBy: orderBy);
      search(state.query);
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

  /// Dispatch a ToggleFilterMenuEvent
  void toggleFilterMenu() {
    dispatch(ToggleFilterMenuEvent());
  }

  /// Dispatch a FilterItemSelectedEvent
  void filterOptionSelected(String type, int index) {
    dispatch(FilterItemSelectedEvent(type: type, index: index));
  }

  /// Dispatch an AvailableFromSelectedEvent
  void setAvailableFrom(String time) {
    dispatch(AvailbleFromSelectedEvent(time: time));
  }

  /// Dispatch an AvailableToSelectedEvent
  void setAvailableTo(String time) {
    dispatch(AvailbleToSelectedEvent(time: time));
  }

  /// Dispatch a ToggleFilterByAvailabilityEvent
  void toggleFilterByAvailability() {
    dispatch(ToggleFilterByAvailabilityEvent());
  }

  /// Dispatch an AvailableDaySelectedEvent
  void availableDaySelected(int index) {
    dispatch(AvailableDaySelectedEvent(index: index));
  }

  /// Dispatch an OrderBySelectedEvent
  void orderBySelected(String type) {
    dispatch(OrderBySelectedEvent(type: type));
  }

  /// Determines whether the filter by availability settings from [availableFrom], [availableTo]
  /// and [availableDaysFilter] overlap with any restaurants' availability settings.
  bool isInsideAvailability(Restaurant restaurant, String availableFrom,
      String availableTo, Map<int, bool> availableDaysFilter) {
    // Separate out components of times
    String availableFromHour = availableFrom.split(":")[0];
    String availableFromMin = availableFrom.split(":")[1];
    String availableToHour = availableTo.split(":")[0];
    String availableToMin = availableTo.split(":")[1];

    List<String> _days = [
      "monday",
      "tuesday",
      "wednesday",
      "thursday",
      "friday",
      "saturday",
      "sunday"
    ];

    DateTime now = DateTime.now();
    DateTime availableFromDate = DateTime.utc(now.year, now.month, now.day,
        int.parse(availableFromHour), int.parse(availableFromMin));
    DateTime availableToDate = DateTime.utc(now.year, now.month, now.day,
        int.parse(availableToHour), int.parse(availableToMin));

    bool ret = false;

    // Iterate only through the days that the user has selected
    for (int dayIndex in availableDaysFilter.keys
        .where((day) => availableDaysFilter[day])
        .toList()) {
      String day = _days[dayIndex];
      // If the restaurant doesn't have this day in their availability map then it's not available!
      if (restaurant.availability[day] == null) continue;
      for (String interval in restaurant.availability[day].keys) {
        // Check it's not fully booked
        if (restaurant.availability[day][interval]['max'] ==
            restaurant.availability[day][interval]['booked']) continue;
        // Separate the components of this time interval
        String startHour = interval.split("-")[0].split(":")[0];
        String startMin = interval.split("-")[0].split(":")[1];
        String endHour = interval.split("-")[1].split(":")[0];
        String endMin = interval.split("-")[1].split(":")[1];

        DateTime start = DateTime.utc(now.year, now.month, now.day,
            int.parse(startHour), int.parse(startMin));
        DateTime end = DateTime.utc(now.year, now.month, now.day,
            int.parse(endHour), int.parse(endMin));

        // Compare user search times and interval times to see if there is any overlap, if so - include
        // the restaurant in the results
        if (isBeforeOrEqual(availableFromDate, start)) {
          if (availableToDate.isAfter(start)) return true;
        } else if (start.isBefore(availableFromDate) &&
            end.isAfter(availableFromDate)) {
          if (availableToDate.isAfter(availableFromDate)) return true;
        }
      }
    }

    return ret;
  }

  /// Determines if a DateTime is before or equal to another.
  bool isBeforeOrEqual(DateTime first, DateTime second) {
    return first.isBefore(second) || first.isAtSameMomentAs(second);
  }

  /// Determines if a DateTime is after or equal to another.
  bool isAfterOrEqual(DateTime first, DateTime second) {
    return first.isAfter(second) || first.isAtSameMomentAs(second);
  }

  /// Converts degrees to radians
  double degreesToRadians(degrees) {
    return degrees * pi / 180;
  }

  /// Calculates the distance across the earth 'as the crow flies' from two sets of coordinates
  double distanceInMiles(lat1, lon1, lat2, lon2) {
    var earthRadiusMiles = 3959;

    var dLat = degreesToRadians(lat2 - lat1);
    var dLon = degreesToRadians(lon2 - lon1);

    lat1 = degreesToRadians(lat1);
    lat2 = degreesToRadians(lat2);

    var a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusMiles * c;
  }

  /// Takes the paired up restaurant and distance tuples and puts them in ascending order of distance.
  /// Uses a merge sort method.
  List<Restaurant> sortByDistance(List<Tuple2> distances) {
    List<Tuple2> sorted = mergeSort(distances, 0, distances.length - 1);
    List<Restaurant> res =
        sorted.map((tup) => tup.item1).toList().cast<Restaurant>();
    res.forEach((restaurant) =>
        restaurant.setDistance(sorted[res.indexOf(restaurant)].item2));
    return res;
  }

  // Merge sort two list of restaurant-distance pairs
  List<Tuple2> mergeSort(List<Tuple2> arr, int low, int high) {
    if (low < high) {
      int m = (low + high) ~/ 2; // does the division but returns int
      List<Tuple2> l1 = mergeSort(arr, low, m);
      List<Tuple2> l2 = mergeSort(arr, m + 1, high);
      return merge(l1, l2);
    } else {
      return [arr[low]];
    }
  }

  // Merge two restaurant-distance pair lists into one
  List<Tuple2> merge(List<Tuple2> l1, List<Tuple2> l2) {
    List<Tuple2> ret = List<Tuple2>();

    int l1Idx = 0, l2Idx = 0;
    while (ret.length != l1.length + l2.length) {
      if (l2Idx == l2.length ||
          (l1Idx < l1.length && l1[l1Idx].item2 <= l2[l2Idx].item2)) {
        ret.add(l1[l1Idx]);
        l1Idx++;
      } else if (l1Idx == l1.length ||
          (l2Idx < l2.length && l2[l2Idx].item2 <= l1[l1Idx].item2)) {
        ret.add(l2[l2Idx]);
        l2Idx++;
      }
    }

    return ret.toList();
  }
}
