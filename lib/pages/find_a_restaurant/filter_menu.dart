import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eat_app/blocs/find_a_restaurant.dart';

import 'package:eat_app/pages/find_a_restaurant/filter_tag.dart';

class FilterMenu extends StatelessWidget {
  Widget build(BuildContext context) {
    FindARestaurantBloc findARestaurantBloc =
        BlocProvider.of<FindARestaurantBloc>(context);

    return BlocBuilder(
      bloc: findARestaurantBloc,
      builder: (BuildContext context, FindARestaurantState state) {
        if (state.filterOptions == null) return Container();
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
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  height: 60.0,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    itemCount: state.filterOptions['category'].length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0)
                        return GestureDetector(
                          onTap: () => findARestaurantBloc.filterOptionSelected(
                              'category', index),
                          child: FilterTag(
                            selected: state.filterOptions['category'][index]
                                ['selected'],
                            title:
                                '${state.filterOptions['category'][index]['name']}',
                            margin: EdgeInsets.only(
                                top: 10.0, right: 10.0, bottom: 10.0),
                          ),
                        );
                      else if (index ==
                          state.filterOptions['category'].length - 1)
                        return GestureDetector(
                          onTap: () => findARestaurantBloc.filterOptionSelected(
                              'category', index),
                          child: FilterTag(
                            selected: state.filterOptions['category'][index]
                                ['selected'],
                            title:
                                '${state.filterOptions['category'][index]['name']}',
                            margin: EdgeInsets.only(
                                left: 10.0, top: 10.0, bottom: 10.0),
                          ),
                        );
                      else
                        return GestureDetector(
                          onTap: () => findARestaurantBloc.filterOptionSelected(
                              'category', index),
                          child: FilterTag(
                            selected: state.filterOptions['category'][index]
                                ['selected'],
                            margin: EdgeInsets.all(10.0),
                            title:
                                '${state.filterOptions['category'][index]['name']}',
                          ),
                        );
                    },
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
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  height: 60.0,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    itemCount: state.filterOptions['location'].length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0)
                        return GestureDetector(
                          onTap: () => findARestaurantBloc.filterOptionSelected(
                              'location', index),
                          child: FilterTag(
                            selected: state.filterOptions['location'][index]
                                ['selected'],
                            title:
                                '${state.filterOptions['location'][index]['name']}',
                            margin: EdgeInsets.only(
                                top: 10.0, right: 10.0, bottom: 10.0),
                          ),
                        );
                      else if (index ==
                          state.filterOptions['location'].length - 1)
                        return GestureDetector(
                          onTap: () => findARestaurantBloc.filterOptionSelected(
                              'location', index),
                          child: FilterTag(
                            selected: state.filterOptions['location'][index]
                                ['selected'],
                            title:
                                '${state.filterOptions['location'][index]['name']}',
                            margin: EdgeInsets.only(
                                left: 10.0, top: 10.0, bottom: 10.0),
                          ),
                        );
                      else
                        return GestureDetector(
                          onTap: () => findARestaurantBloc.filterOptionSelected(
                              'location', index),
                          child: FilterTag(
                            selected: state.filterOptions['location'][index]
                                ['selected'],
                            margin: EdgeInsets.all(10.0),
                            title:
                                '${state.filterOptions['location'][index]['name']}',
                          ),
                        );
                    },
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
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
      },
    );
  }
}
