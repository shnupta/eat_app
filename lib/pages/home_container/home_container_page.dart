import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:eat_app/pages/home.dart';
import 'package:eat_app/pages/settings.dart';
import 'package:eat_app/pages/find_a_restaurant.dart';

import 'package:eat_app/blocs/news.dart';
import 'package:eat_app/blocs/find_a_restaurant.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

// This page will be responsible for initialising the blocs that will be needed by child pages.
// It will also act as a kind of container around all the other pages that can be visited when
// a user is logged in.

class HomeContainerPage extends StatelessWidget {

  GoogleMapController _googleMapController;

  final NewsBloc newsBloc = NewsBloc();
	final FindARestaurantBloc findARestaurantBloc = FindARestaurantBloc();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: <Widget>[
            BlocProvider(bloc: newsBloc, child: HomePage(),),
            BlocProvider(bloc: findARestaurantBloc, child: FindARestaurantPage()),
            Container(
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) => null,
              ),
            ),
            SettingsPage(),
          ],
        ),
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: TabBar(
            indicatorWeight: 4.0,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.redAccent,
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.blueGrey[300],
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.search),
              ),
              Tab(
                icon: Icon(Icons.receipt),
              ),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
        ),
      ),
    );
  }
}
