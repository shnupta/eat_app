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
  final BuildContext context;

  BookingDialog(
      {@required this.restaurant,
      @required this.date,
      @required this.day,
      @required this.restaurantProfileBloc,
      @required this.context,
      });

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
      DateTime now = DateTime.now();
      if(now.weekday - 1 == _days.indexOf(widget.day)) 
        return widget.restaurant.isInsideAvailability(time, time, daysFilter) && ((int.parse(time.split(':')[0]) >= now.hour) && (int.parse(time.split(':')[1]) > now.minute));
      else return widget.restaurant.isInsideAvailability(time, time, daysFilter);
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
          if (state.finished != null && state.finished) {
            widget.restaurantProfileBloc.allowPopupClosing();
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
                      content: Text(state.error, textAlign: TextAlign.center,),
                    ),
              );
              bookingBloc.errorShown();
              widget.restaurantProfileBloc.allowPopupClosing();
            });
          }

          if (state.isLoading != null && state.isLoading) {
            widget.restaurantProfileBloc.preventPopupClosing();
            return Container(
              height: 100,
              width: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.showConfirmation != null && state.showConfirmation) {
            widget.restaurantProfileBloc.allowPopupClosing();
            return _buildOrderConfirmationBody(state, _months);
          } else if (state.showReceipt != null && state.showReceipt) {
            widget.restaurantProfileBloc.allowPopupClosing();
            return _buildReceiptBody(state, _months);
          } else if (state.showTransactionError != null &&
              state.showTransactionError) {
                widget.restaurantProfileBloc.allowPopupClosing();
            return _buildTransactionErrorBody(state);
          } else {
            widget.restaurantProfileBloc.allowPopupClosing();
            return _buildStandardBody(state, _months, _validTimes);
          }
        },
      ),
    );
  }

  Widget _buildReceiptBody(BookingState state, List<String> _months) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Confirmation of your purchase',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Transaction Id: ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${state.voucher.transactionId}',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Voucher Id: ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${state.voucher.id}',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'These details are also visible from your vouchers page.',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOrderConfirmationBody(BookingState state, List<String> _months) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10),
          Text(
            'Confirm your order',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text('Voucher for ${state.restaurant.name}'),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: Text(
              'Number of people: ${state.numberOfPeople}\nTime: ${state.selectedTime}\nDate: ${state.day.replaceFirst(state.day[0], state.day[0].toUpperCase())} ${state.date.day} ${_months[state.date.month]}\nPrice: £${state.numberOfPeople}.00',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 20),
          StandardFilledButton(
            text: 'Purchase',
            onPressed: () => bookingBloc.orderConfirmed(),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardBody(
      BookingState state, List<String> _months, List<String> _validTimes) {
    if(_validTimes.length == 0) {
      return Container(
        padding: EdgeInsets.all(20),
        child: Text('No times are left for today.',
        style: TextStyle(
          fontSize: 20,
        ),
        textAlign: TextAlign.center,),
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
                            onChanged: (time) => bookingBloc.timeSelected(time),
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
  }

  Widget _buildTransactionErrorBody(BookingState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Text(
        'An error occured: ${state.transactionError}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}
