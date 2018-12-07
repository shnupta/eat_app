import 'package:flutter/material.dart';

class RestaurantProfilePage extends StatelessWidget {

  final String name;

  RestaurantProfilePage({@required this.name});

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(this.name),
        ),
      );
    }
}