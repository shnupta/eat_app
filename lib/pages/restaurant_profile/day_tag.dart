import 'package:flutter/material.dart';

import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as vm;

/// A custom tag used in the [FilterMenu] that is typically wrapped in a custom [GestureDetector] to enable
/// it to interact with a bloc when selected.
class DayTag extends StatelessWidget {
  final EdgeInsets margin;
  final String day;
  final int date;
  final bool closed;
  final bool fullyBooked;
  final Color borderColour;
  final Color textColour;
  final double width;
  final double height;
  final double borderRadius;

  DayTag(
      {@required this.day,
      @required this.date,
      this.margin =
          const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      this.width = 100,
      this.height = 40,
      this.borderRadius = 20,
      this.borderColour = Colors.grey,
      this.textColour = Colors.black,
      this.closed,
      this.fullyBooked});

  Widget build(BuildContext context) {
    if (closed) {
      return Stack(
        children: <Widget>[
          Container(
            width: width,
            height: height,
            margin: margin,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: this.borderColour,
              ),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        '$day',
                        style: TextStyle(
                          color: this.textColour,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '$date',
                        style: TextStyle(
                          color: this.textColour,
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    transform: Matrix4.compose(
                        vm.Vector3.array([8, -15, 0]),
                        vm.Quaternion.axisAngle(
                            vm.Vector3.array([0, 0, 1]), (pi / 4)),
                        vm.Vector3.array([1.3,1,1])),
                    color: Colors.red[800].withAlpha(150),
                    height: 15,
                    width: 40,
                    child: Text(
                      'CLOSED',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                      ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (fullyBooked) {
      return Stack(
        children: <Widget>[
          Container(
            width: width,
            height: height,
            margin: margin,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: this.borderColour,
              ),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        '$day',
                        style: TextStyle(
                          color: this.textColour,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '$date',
                        style: TextStyle(
                          color: this.textColour,
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    transform: Matrix4.compose(
                        vm.Vector3.array([8, -15, 0]),
                        vm.Quaternion.axisAngle(
                            vm.Vector3.array([0, 0, 1]), (pi / 4)),
                        vm.Vector3.array([1.3,1,1])),
                    color: Colors.black.withAlpha(150),
                    height: 15,
                    width: 40,
                    child: Text(
                      'BOOKED',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                      ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // Available to book
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: this.borderColour,
        ),
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              '$day',
              style: TextStyle(
                color: this.textColour,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              '$date',
              style: TextStyle(
                color: this.textColour,
                fontSize: 12,
                fontWeight: FontWeight.w200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
