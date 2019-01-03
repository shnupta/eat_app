import 'package:flutter/material.dart';

class BookingDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Text('Book your table'),
      ),
    );
  }
}
