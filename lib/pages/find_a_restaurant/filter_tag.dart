import 'package:flutter/material.dart';

class FilterTag extends StatelessWidget {
	final EdgeInsets margin;
	final String title;
  final bool selected;
  final Color selectedColor;
  final Color unselectedColor;

	FilterTag({@required this.title, this.margin = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), this.selected = false,
  this.selectedColor, this.unselectedColor});
	

  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      margin: margin,
			decoration: BoxDecoration(
        color: this.selected ? (selectedColor ?? Theme.of(context).accentColor) : (unselectedColor ?? Colors.grey[400]),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: Text(
						title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
