import 'package:flutter/material.dart';

import 'package:snacc/models.dart';
import 'package:snacc/widgets.dart';
import 'package:snacc/blocs/booking.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class BookingDialog extends StatelessWidget {
  final Restaurant restaurant;
  final DateTime date;
  final String day;

  final BookingBloc bookingBloc = BookingBloc();

  BookingDialog(
      {@required this.restaurant, @required this.date, @required this.day});

  @override
  Widget build(BuildContext context) {
    List<String> _times = List.generate(
        48,
        (int increment) =>
            ((increment * 30) / 60).floor().toString() +
            ":" +
            ((increment % 2 == 0) ? "00" : "30"));
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
          if (state.isInitialising == null || state.isInitialising) {
            bookingBloc.initialise(restaurant, date, day);
            return Container(
              child: Text('Initialising...'),
            );
          }

          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Book for ${day.replaceFirst(day[0], day[0].toUpperCase())} ${date.day} ${_months[date.month]}',
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
                            child: Text(
                              'Number of people:',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(child: NumberPicker(
                            value: state.numberOfPeople,
                            minValue: 1,
                            maxValue: 6,
                            onChanged: (picked) => bookingBloc.numberOfPeopleSelected(picked),
                          )),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text('Time:'),
                        ],
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
