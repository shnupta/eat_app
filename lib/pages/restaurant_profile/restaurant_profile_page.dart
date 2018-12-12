import 'package:flutter/material.dart';

import 'package:snacc/models.dart';

class RestaurantProfilePage extends StatelessWidget {

  final Restaurant restaurant;

  RestaurantProfilePage({@required this.restaurant});

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(this.restaurant.name),
          backgroundColor: Theme.of(context).accentColor,
        ),
        body: Center(
          child: Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(restaurant.logoUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
      );
    }
}