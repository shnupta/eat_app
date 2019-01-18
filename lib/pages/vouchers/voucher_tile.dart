import 'package:flutter/material.dart';

import 'package:snacc/models.dart';

import 'package:date_utils/date_utils.dart' as du;

class VoucherTile extends StatelessWidget {
  final Voucher voucher;

  VoucherTile({@required this.voucher});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(voucher.restaurant.name),
      subtitle: Text(
          '${voucher.bookingDay[0].toUpperCase()}${voucher.bookingDay.substring(1)} ${voucher.bookingTime.day} ${du.Utils.formatMonth(voucher.bookingTime)} at ${voucher.bookingTime.hour}:${voucher.bookingTime.minute} for ${voucher.numberOfPeople} people.'),
    );
  }
}
