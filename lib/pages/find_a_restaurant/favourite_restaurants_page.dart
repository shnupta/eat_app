import 'package:flutter/material.dart';

import 'package:snacc/models.dart';
import 'package:snacc/pages/find_a_restaurant/result_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouriteRestaurantsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FavouriteRestaurantState();
  }
}

class _FavouriteRestaurantState extends State<FavouriteRestaurantsPage> {
  List<Restaurant> restaurants;
  @override
  void initState() {
    loadFavourites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your favourite restaurants'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (restaurants != null && restaurants.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(top: 20),
        child: ListView(
          children: restaurants.map((rest) => ResultTile(rest)).toList(),
        ),
      );
    } else if(restaurants == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: Text('You have not favourited any restaurants!'),
      );
    }
  }

  void loadFavourites() async {
    User user =
        User.fromFirebaseUser(await FirebaseAuth.instance.currentUser());
    List<String> ids = await user.getFavouriteRestaurants();
    List<Restaurant> rests = List();
    for (String id in ids) {
      rests.add(await Restaurant.fromId(id));
    }

    setState(() {
      restaurants = rests;
    });
  }
}
