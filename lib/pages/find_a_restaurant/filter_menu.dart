import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacc/blocs/find_a_restaurant.dart';

import 'package:snacc/pages/find_a_restaurant/filter_tag.dart';

class FilterMenu extends StatelessWidget {
  Widget build(BuildContext context) {
    List<String> _times = List.generate(
        48,
        (int increment) =>
            ((increment * 30) / 60).floor().toString() +
            ":" +
            ((increment % 2 == 0) ? "00" : "30"));
    List<String> _days = ["M", "T", "W", "T", "F", "S", "S"];

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
                            selectedColor: Theme.of(context).primaryColor,
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
                            selectedColor: Theme.of(context).primaryColor,
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
                            selectedColor: Theme.of(context).primaryColor,
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
                  margin: EdgeInsets.only(right: 10.0, top: 10.0),
                  height: 60.0,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.center,
                          child: DropdownButton(
                            value: state.availableFrom,
                            onChanged: (dynamic time) =>
                                findARestaurantBloc.setAvailableFrom(time),
                            items: _times
                                .map(
                                  (time) => DropdownMenuItem(
                                        child: Text(time),
                                        value: time,
                                      ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            'to',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          alignment: Alignment.center,
                          child: DropdownButton(
                            value: state.availableTo,
                            onChanged: (dynamic time) =>
                                findARestaurantBloc.setAvailableTo(time),
                            items: _times
                                .map(
                                  (time) => DropdownMenuItem(
                                      child: Text(time), value: time),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Checkbox(
                            value: state.filterByAvailability,
                            onChanged: (bool val) => findARestaurantBloc
                                .toggleFilterByAvailability(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                  height: 60.0,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: ListView.builder(
                    itemCount: _days.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () =>
                            findARestaurantBloc.availableDaySelected(index),
                        child: FilterTag(
                          selectedColor: Theme.of(context).primaryColorDark,
                          width: 40,
                          height: 20,
                          selected: state.availableFilterDays[index],
                          title: '${_days[index]}',
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: Text(
                    'Order by',
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
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () => findARestaurantBloc.orderBySelected('relevance'),
                          child: FilterTag(
                            selected: state.orderBy['relevance'],
                            selectedColor: Theme.of(context).cursorColor,
                            title: 'Relevance',
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => findARestaurantBloc.orderBySelected('popularity'),
                          child: FilterTag(
                            selected: state.orderBy['popularity'],
                            selectedColor: Theme.of(context).cursorColor,
                            title: 'Popularity',
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => findARestaurantBloc.orderBySelected('distance'),
                          child: FilterTag(
                            selected: state.orderBy['distance'],
                            selectedColor: Theme.of(context).cursorColor,
                            title: 'Distance',
                          ),
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
