import 'package:flutter/material.dart';

import 'package:snacc/models.dart';
import 'package:snacc/widgets.dart';

import 'package:snacc/pages/restaurant_profile/day_tag.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacc/blocs/restaurant_profile.dart';

import 'package:date_utils/date_utils.dart' as du;

import 'package:snacc/pages/map_view.dart';

class RestaurantProfilePage extends StatelessWidget {
  final Restaurant restaurant;

  RestaurantProfilePage({@required this.restaurant});

  @override
  Widget build(BuildContext context) {
    RestaurantProfileBloc restaurantProfileBloc = RestaurantProfileBloc();

    List<String> _fullDays = [
      "monday",
      "tuesday",
      "wednesday",
      "thursday",
      "friday",
      "saturday",
      "sunday"
    ];
    List<String> _days = ["M", "T", "W", "T", "F", "S", "S"];
    DateTime now = DateTime.now();

    _days = _shiftDays(_days, (now.weekday - 1));
    _fullDays = _shiftDays(_fullDays, (now.weekday - 1));

    return Scaffold(
      body: BlocBuilder(
          bloc: restaurantProfileBloc,
          builder: (BuildContext context, RestaurantProfileState state) {
            List<Widget> items = [];
            items.add(_buildMainPage(
                context, _days, _fullDays, now, restaurantProfileBloc));

            if (state.showDayBookingPopup != null &&
                state.showDayBookingPopup) {
              items.add(GestureDetector(
                  onTap: () => restaurantProfileBloc.closePopup(),
                  child: Container(
                    color: Colors.black.withAlpha(170),
                  )));
              items.add(BookingDialog(
                  restaurant: restaurant,
                  date: _findNextDateOfDay(state.selectedDay, _fullDays),
                  day: state.selectedDay,
                  restaurantProfileBloc: restaurantProfileBloc,
                  context: context));
            }
            return Stack(
              children: items,
            );
          }),
    );
  }

  Widget _buildBody(
      BuildContext context,
      List<String> _days,
      List<String> _fullDays,
      DateTime now,
      RestaurantProfileBloc restaurantProfileBloc) {
    return Column(
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
                      Container(
                        padding: EdgeInsets.only(top: 2),
                        child: Text(
                          '${restaurant.discount}% off!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
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
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: ListView.builder(
            itemCount: _days.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                splashColor: (restaurant.isClosed(_fullDays[index]) ||
                        restaurant.isFullyBooked(_fullDays[index]))
                    ? Colors.grey
                    : Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  return (restaurant.isClosed(_fullDays[index]) ||
                          restaurant.isFullyBooked(_fullDays[index]))
                      ? null
                      : restaurantProfileBloc.selectDay(_fullDays[index]);
                }, // Conditional on whether it is closed or fully booked, if not allow them to press
                child: DayTag(
                  borderColour: Colors.grey,
                  textColour: Theme.of(context).primaryColorDark,
                  width: 40,
                  height: 40,
                  closed: restaurant.isClosed(_fullDays[index]),
                  fullyBooked: restaurant.isFullyBooked(_fullDays[index]),
                  day: '${_days[index]}',
                  date:
                      du.Utils.isLastDayOfMonth(now.add(Duration(days: index)))
                          ? du.Utils.lastDayOfMonth(now).day
                          : (now.day + index) %
                              du.Utils.lastDayOfMonth(now).day,
                  margin: EdgeInsets.symmetric(
                      vertical: 9.0,
                      horizontal:
                          ((MediaQuery.of(context).size.width - 300) / 14)),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StandardOutlinedButton(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: (MediaQuery.of(context).size.width / 2) - 30,
              text: 'View map',
              onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => MapViewPage(
                          viewRestaurant: true, viewingRestaurant: restaurant),
                    ),
                  ),
            ),
            SizedBox(width: 20),
            StandardOutlinedButton(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: (MediaQuery.of(context).size.width / 2) - 30,
              text: 'View menu',
              onPressed: () => null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMainPage(
      BuildContext context,
      List<String> _days,
      List<String> _fullDays,
      DateTime now,
      RestaurantProfileBloc restaurantProfileBloc) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        SliverFillRemaining(
          child:
              _buildBody(context, _days, _fullDays, now, restaurantProfileBloc),
        ),
      ],
    );
  }

  /// [cur] is the current order of the days of the week
  /// [index] is the index of the current day (which should be first in the list)
  List<String> _shiftDays(List<String> cur, int index) {
    List<String> ret = List(cur.length);
    int pos =
        index; // The position in the cur array of the day we wish to add to the ret array
    for (int i = 0; i < cur.length; i++) {
      ret[i] = cur[pos % cur.length];
      pos++;
    }

    return ret;
  }

  /// Returns the next date where the day of the week is [day]
  DateTime _findNextDateOfDay(String day, List<String> fullDays) {
    return DateTime.now().add(Duration(days: fullDays.indexOf(day)));
  }
}
