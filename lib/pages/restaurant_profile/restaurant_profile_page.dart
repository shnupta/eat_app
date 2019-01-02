import 'package:flutter/material.dart';

import 'package:snacc/models.dart';

import 'package:snacc/pages/restaurant_profile/day_tag.dart';

class RestaurantProfilePage extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantProfilePage({@required this.restaurant});

  @override
  Widget build(BuildContext context) {
    List<String> _days = ["M", "T", "W", "T", "F", "S", "S"];

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          SliverFillRemaining(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  restaurant.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        '${restaurant.category} | ${restaurant.location}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Icon(Icons.star),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CircleAvatar(
                        minRadius: 60,
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(restaurant.logoUrl),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: ListView.builder(
                    itemCount: _days.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () =>
                            null, //findARestaurantBloc.availableDaySelected(index),
                        child: DayTag(
                          selectedColor: Theme.of(context).primaryColor,
                          borderColour: Colors.grey,
                          unselectedColor: Colors.transparent,
                          textColour: Theme.of(context).primaryColorDark,
                          width: 40,
                          height: 40,
                          //selected: state.availableFilterDays[index],
                          title: '${_days[index]}',
                          margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: ((MediaQuery.of(context).size.width - 300) / 14)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
