import 'package:flutter/material.dart';

import 'package:snacc/database.dart';

/// The [Restaurant] class will be widely used throughout the app. It contains information that will
/// be used to display info about the restaurant on pages such as the find a restaurant page, map view,
/// restaurant profile page etc.
class Restaurant {
  /// Main display name of the restaurant.
  final String name;

  /// Typically a long text written by the restaurant to describe/advertise themself.
  final String description;

  /// ID of the object in firebase
  final String id;

  /// URL of the restaurant's logo image
  final String logoUrl;

  /// Map of the availability of booking data for a restaurant
  final Map<String, dynamic> availability;

  /// Map of the GPS coordinates of the restaurant
  final Map<String, dynamic> latLong;

  /// Location of the restaurant
  final String location;

  /// The main type of food that the restaurant serves
  final String category;

  /// The distance in miles from the user, can be set later
  double distanceFromUser;

  Restaurant(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.logoUrl,
      @required this.availability,
      @required this.latLong,
      @required this.location,
      @required this.category,
      this.distanceFromUser});

  void setDistance(double dist) => distanceFromUser = dist;

  /// Constructs a [Restaurant] object from a hit object of an Algolia search response
  factory Restaurant.fromAlgoliaMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['objectID'],
      name: map['name'],
      description: map['description'],
      logoUrl: map['logoUrl'] ??
          "https://firebasestorage.googleapis.com/v0/b/eat-app-d60bf.appspot.com/o/no-logo.png?alt=media&token=61db48f4-27f7-4862-82de-40980649fd17",
      availability: map['availability'] ?? Map(),
      latLong: map['lat_long'] != null
          ? {
              "latitude": map['lat_long']['_latitude'],
              "longitude": map['lat_long']['_longitude']
            }
          : Map(),
      location: map['location'],
      category: map['category'],
    );
  }

  factory Restaurant.fromMap(Map<String, dynamic> map) {
    return Restaurant(
      id: map['id'],
        name: map['name'],
        description: map['description'],
        logoUrl: map['logoUrl'],
        availability: map['availability'] != null ? Map<String, dynamic>.from(map['availability']) : Map(),
        latLong: map['lat_long'] != null
            ? {
                "latitude": map['lat_long'].latitude,
                "longitude": map['lat_long'].longitude,
              }
            : Map(),
        location: map['location'],
        category: map['category']
    );
  }

  static Future<Restaurant> fromId(String id) async {
    Map<String, dynamic> data =
        await Database.readDocumentAtCollectionWithId('restaurants', id);
    return Future.value(Restaurant(
        id: data['id'],
        name: data['name'],
        description: data['description'],
        logoUrl: data['logoUrl'],
        availability: data['availability'] != null ? Map<String, dynamic>.from(data['availability']) : Map(),
        latLong: data['lat_long'] != null
            ? {
                "latitude": data['lat_long'].latitude,
                "longitude": data['lat_long'].longitude,
              }
            : Map(),
        location: data['location'],
        category: data['category']));
  }

  /// Determines whether the filter by availability settings from [availableFrom], [availableTo]
  /// and [availableDaysFilter] overlap with any restaurants' availability settings.
  bool isInsideAvailability(String availableFrom, String availableTo,
      Map<int, bool> availableDaysFilter) {
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
      if (this.availability[day] == null) continue;
      for (String interval in this.availability[day].keys) {
        if (interval == 'closed') continue;
        // Check it's not fully booked
        if (this.availability[day][interval]['max'] ==
            this.availability[day][interval]['booked']) continue;
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
        if (_isBeforeOrEqual(availableFromDate, start)) {
          if (_isAfterOrEqual(availableToDate, start)) return true;
        } else if (_isBeforeOrEqual(start, availableFromDate) &&
            _isAfterOrEqual(end, availableFromDate)) {
          if (_isAfterOrEqual(availableToDate, availableFromDate)) return true;
        }
      }
    }

    return ret;
  }

  /// Determines if a DateTime is before or equal to another.
  bool _isBeforeOrEqual(DateTime first, DateTime second) {
    return first.isBefore(second) || first.isAtSameMomentAs(second);
  }

  bool _isAfterOrEqual(DateTime first, DateTime second) {
    return first.isAfter(second) || first.isAtSameMomentAs(second);
  }

  /// Indicated whether a restaurant is closed on a certain day of the current week
  bool isClosed(String day) {
    if (this.availability[day] == null) return true;
    return (this.availability[day]['closed'] ?? true);
  }

  /// Determines if a restaurant is fully booked on a certain day of the current week
  bool isFullyBooked(String day) {
    bool ret = true;
    if (this.availability[day] == null) return true;
    for (String interval in this.availability[day].keys) {
      if (interval == 'closed') continue;
      if (this.availability[day][interval]['booked'] <
          this.availability[day][interval]['max']) ret = false;
    }

    return ret;
  }

  static Future<List<Restaurant>> loadAll() async {
    List<Map<String, dynamic>> restaurants = await Database.readDocumentsAtCollection('restaurants');
    return Future.value(restaurants.map((doc) => Restaurant.fromMap(doc)).toList());

  }
}
