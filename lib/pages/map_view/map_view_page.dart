import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:snacc/models.dart';

import 'package:snacc/pages/restaurant_profile.dart';

import 'package:location/location.dart';

/// The [MapViewPage] displays a google map that the user interacts with to see the locations
/// of restaurants.
class MapViewPage extends StatefulWidget {
  /// If only one restaurant is to be viewed then it will be passed in the constructor
  /// and will be the only marker on the map.
  final bool viewRestaurant;

  /// The restaurant to view if it is the only one.
  final Restaurant viewingRestaurant;

  MapViewPage({this.viewRestaurant = false, this.viewingRestaurant});

  @override
  State<StatefulWidget> createState() {
    return _MapViewState();
  }
}

class _MapViewState extends State<MapViewPage> {
  GoogleMapController mapController;
  List<Restaurant> allRestaurants;
  // Set when the user clicks on a marker
  Restaurant selectedRestaurant;

  Map<MarkerId, Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints contraints) {
          return Container(
            child: GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(53.134304, -2.8291387),
                zoom: 5.0,
              ),
              markers: Set<Marker>.of(markers.values),
            ),
          );
        },
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    List<Restaurant> rests = await Restaurant.loadAll();
    setState(() {
      mapController = controller;

      setState(() {
        allRestaurants = rests;
      });
    });

    // If we only want to view one specific restaurant, then zoom into that at the beginning
    if (widget.viewRestaurant) {
      double lat = widget.viewingRestaurant.latLong['latitude'];
      double long = widget.viewingRestaurant.latLong['longitude'];

      Marker restMarker = Marker(
        markerId: MarkerId(widget.viewingRestaurant.id),
        position: LatLng(lat, long),
        infoWindow: InfoWindow(
            onTap: _handleInfoWindowTap,
            title: widget.viewingRestaurant.name,
            snippet: widget.viewingRestaurant.description.substring(
                    0,
                    widget.viewingRestaurant.description.length - 1 < 50
                        ? widget.viewingRestaurant.description.length - 1
                        : 50) +
                '...'),
        onTap: () => _handleMarkerTap(MarkerId(widget.viewingRestaurant.id)),
      );

      setState(() {
        markers[MarkerId(widget.viewingRestaurant.id)] = restMarker;
      });

      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0.0,
          target: LatLng(lat, long),
          tilt: 0.0,
          zoom: 17.0,
        ),
      ));
    } else {
      // Show all markers in view

      allRestaurants.forEach((rest) => markers[MarkerId(rest.id)] = (
        Marker(
          markerId: MarkerId(rest.id),
          onTap: () => _handleMarkerTap(MarkerId(rest.id)),
            infoWindow: InfoWindow(
                onTap: _handleInfoWindowTap,
                title: rest.name,
                snippet: rest.description.substring(
                        0,
                        rest.description.length - 1 < 50
                            ? rest.description.length - 1
                            : 50) +
                    '...'),
            position:
                LatLng(rest.latLong['latitude'], rest.latLong['longitude']),
          )));
      Location userLocation = new Location();
      Map<String, double> loc = Map();
      try {
        loc = await userLocation.getLocation();
      } catch (e) {
        print('error');
      }
      mapController.animateCamera(
        // navigate to the user's position
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(loc['latitude'], loc['longitude']),
            zoom: 12.0,
          ),
        ),
      );
    }
  }

  /// When a marker is tapped, set the selected restaurant. This enables us to choose
  /// which restaurant's profile page is opened when the info window is tapped.
  void _handleMarkerTap(MarkerId markerId) {
    Restaurant restaurant = allRestaurants
        .where((rest) =>
            (rest.latLong['latitude'] as double).toStringAsPrecision(8) ==
                markers[markerId].position.latitude.toStringAsPrecision(8) &&
            (rest.latLong['longitude'] as double).toStringAsPrecision(8) ==
                markers[markerId].position.longitude.toStringAsPrecision(8))
        .toList()[0];

    setState(() {
      selectedRestaurant = restaurant;
    });
  }

  void _handleInfoWindowTap() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => RestaurantProfilePage(
            restaurant: selectedRestaurant,
          ),
    ));
  }
}
