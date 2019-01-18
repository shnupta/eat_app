import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:snacc/models.dart';

import 'package:snacc/pages/restaurant_profile.dart';

class MapViewPage extends StatefulWidget {
  final bool viewRestaurant;
  final Restaurant viewingRestaurant;

  MapViewPage({this.viewRestaurant, this.viewingRestaurant});

  @override
  State<StatefulWidget> createState() {
    return _MapViewState();
  }
}

class _MapViewState extends State<MapViewPage> {
  GoogleMapController mapController;

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

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    if (widget.viewRestaurant) {
      double lat = widget.viewingRestaurant.latLong['latitude'];
      double long = widget.viewingRestaurant.latLong['longitude'];
      mapController.addMarker(MarkerOptions(
        position: LatLng(lat, long),
        infoWindowText: InfoWindowText(widget.viewingRestaurant.name,
            widget.viewingRestaurant.description.substring(0, widget.viewingRestaurant.description.length - 1 < 50 ?  widget.viewingRestaurant.description.length - 1 : 50) + '...'),
      ));
      mapController.onInfoWindowTapped
          .add((infoWindow) => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => RestaurantProfilePage(
                      restaurant: widget.viewingRestaurant,
                    ),
              )));
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0.0,
          target: LatLng(lat, long),
          tilt: 0.0,
          zoom: 17.0,
        ),
      ));
    }
  }
}
