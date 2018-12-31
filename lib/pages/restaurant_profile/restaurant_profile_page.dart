import 'package:flutter/material.dart';

import 'package:snacc/models.dart';

class RestaurantProfilePage extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantProfilePage({@required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(restaurant.name),
          ),
          SliverFillRemaining(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 100,
                        color: Colors.green,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: CircleAvatar(
                        minRadius: 50,
                        maxRadius: 50,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(restaurant.logoUrl),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
