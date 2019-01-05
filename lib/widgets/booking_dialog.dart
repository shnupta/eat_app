import 'package:flutter/material.dart';

import 'package:snacc/models.dart';
import 'package:snacc/widgets.dart';
import 'package:snacc/blocs/booking.dart';

import 'package:snacc/blocs/restaurant_profile.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class BookingDialog extends StatefulWidget {
  final Restaurant restaurant;
  final DateTime date;
  final String day;
  final RestaurantProfileBloc restaurantProfileBloc;

  BookingDialog(
      {@required this.restaurant, @required this.date, @required this.day, @required this.restaurantProfileBloc});

  @override
  State<StatefulWidget> createState() {
    return _BookingDialogState();
  }
}

class _BookingDialogState extends State<BookingDialog> {
  BookingBloc bookingBloc = BookingBloc();

  @override
  Widget build(BuildContext context) {
    List<String> _times = List.generate(
        48,
        (int increment) =>
            ((increment * 30) / 60).floor().toString() +
            ":" +
            ((increment % 2 == 0) ? "00" : "30"));

    List<String> _days = [
      "monday",
      "tuesday",
      "wednesday",
      "thursday",
      "friday",
      "saturday",
      "sunday"
    ];

    List<String> _validTimes = _times.where((time) {
      Map<int, bool> daysFilter = {
        _days.indexOf(widget.day): true,
      };
      return widget.restaurant.isInsideAvailability(time, time, daysFilter);
    }).toList();

    List<String> _months = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return Dialog(
      child: BlocBuilder(
        bloc: bookingBloc,
        builder: (BuildContext context, BookingState state) {
          if(state.finished != null && state.finished) {
            widget.restaurantProfileBloc.closePopup();
          }

          if (state.isInitialising == null || state.isInitialising) {
            bookingBloc.initialise(widget.restaurant, widget.date, widget.day);
            return SizedBox();
          }

          if (state.error != null && state.error.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text(state.error),
                    ),
              );
              bookingBloc.errorShown();
            });
          }

          if (state.isLoading != null && state.isLoading) {
            return Container(
              height: 100,
              width: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 10),
                Text(
                  'Book for ${state.day.replaceFirst(state.day[0], state.day[0].toUpperCase())} ${state.date.day} ${_months[state.date.month]}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Number of people:',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Column(
                            children: <Widget>[
                              NumberPicker(
                                value: state.numberOfPeople,
                                minValue: 2,
                                maxValue: 6,
                                onChanged: (picked) =>
                                    bookingBloc.numberOfPeopleSelected(picked),
                              ),
                            ],
                          )),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  'Time:',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                DropdownButton(
                                  value: state.selectedTime,
                                  items: _validTimes
                                      .map((time) => DropdownMenuItem(
                                            child: Text(time),
                                            value: time,
                                          ))
                                      .toList(),
                                  onChanged: (time) =>
                                      bookingBloc.timeSelected(time),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        child: StandardFilledButton(
                          text: 'Book Now',
                          onPressed: () => bookingBloc.bookNowPressed(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
