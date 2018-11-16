import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eat_app/blocs/find_a_restaurant.dart';

class FilterMenu extends StatelessWidget {
  Widget build(BuildContext context) {
    FindARestaurantBloc findARestaurantBloc =
        BlocProvider.of<FindARestaurantBloc>(context);

    return Column(
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 20.0, top: 20.0),
              child: Text(
                'Category',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              height: 60.0,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    width: 75.0,
                    color: Colors.red,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.orange,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.green,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.red,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.orange,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.green,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.red,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.orange,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 20.0, top: 20.0),
              child: Text(
                'Location',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              height: 60.0,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Container(
                    width: 75.0,
                    color: Colors.red,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.orange,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.green,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.red,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.orange,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.green,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.red,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.orange,
                  ),
                  Container(
                    width: 75.0,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 20.0, top: 20.0),
              child: Text(
                'Availability',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              height: 60.0,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.pink,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
