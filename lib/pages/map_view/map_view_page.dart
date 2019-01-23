import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:snacc/models.dart';

import 'package:snacc/pages/restaurant_profile.dart';

import 'package:location/location.dart';

class MapViewPage extends StatefulWidget {
  final bool viewRestaurant;
  final Restaurant viewingRestaurant;

  MapViewPage({this.viewRestaurant = false, this.viewingRestaurant});

  @override
  State<StatefulWidget> createState() {
    return _MapViewState();
  }
}

class _MapViewState extends State<MapViewPage> {
  GoogleMapController mapController;
  List<Restaurant> restaurantsInView;
  List<Restaurant> allRestaurants;
  Restaurant selectedRestaurant;

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
              options: GoogleMapOptions(
                myLocationEnabled: true,
                compassEnabled: true,
              ),
              onMapCreated: _onMapCreated,
            ),
          );
        },
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });

    mapController.onMarkerTapped.add((marker) => _handleMarkerTap(marker));

    mapController.onInfoWindowTapped
        .add((infoWindow) => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => RestaurantProfilePage(
                    restaurant: selectedRestaurant,
                  ),
            )));

    if (widget.viewRestaurant) {
      double lat = widget.viewingRestaurant.latLong['latitude'];
      double long = widget.viewingRestaurant.latLong['longitude'];
      mapController.addMarker(MarkerOptions(
        position: LatLng(lat, long),
        infoWindowText: InfoWindowText(
            widget.viewingRestaurant.name,
            widget.viewingRestaurant.description.substring(
                    0,
                    widget.viewingRestaurant.description.length - 1 < 50
                        ? widget.viewingRestaurant.description.length - 1
                        : 50) +
                '...'),
      ));
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

      List<Restaurant> rests = await Restaurant.loadAll();
      setState(() {
        allRestaurants = rests;
      });

      allRestaurants.forEach((rest) => mapController.addMarker(MarkerOptions(
            infoWindowText: InfoWindowText(
                rest.name,
                rest.description.substring(
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

  void _handleMarkerTap(Marker marker) {
    Restaurant restaurant = allRestaurants
        .where((rest) =>
            (rest.latLong['latitude'] as double).toStringAsPrecision(8) == marker.options.position.latitude.toStringAsPrecision(8) &&
            (rest.latLong['longitude'] as double).toStringAsPrecision(8) == marker.options.position.longitude.toStringAsPrecision(8))
        .toList()[0];
    setState(() {
      selectedRestaurant = restaurant;
    });
  }
}
