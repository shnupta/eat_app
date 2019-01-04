import 'package:flutter/material.dart';

class NumberPicker extends StatelessWidget {
  final ValueChanged<int> onChanged;

  final int value;

  final int minValue;

  final int maxValue;

  NumberPicker({
    @required this.onChanged,
    @required this.value,
    @required this.minValue,
    @required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '<',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            onTap: () => (value - 1) < minValue ? null : onChanged(value - 1),
            borderRadius: BorderRadius.circular(30),
          ),
          SizedBox(width: 8),
          Text(
            value.toString(),
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 22,
            ),
          ),
          SizedBox(width: 8),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '>',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            onTap: () => (value + 1) > maxValue ? null : onChanged(value + 1),
            borderRadius: BorderRadius.circular(30),
          ),
        ],
      ),
    );
  }
}
