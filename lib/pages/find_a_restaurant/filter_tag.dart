import 'package:flutter/material.dart';

/// A custom tag used in the [FilterMenu] that is typically wrapped in a custom [GestureDetector] to enable
/// it to interact with a bloc when selected.
class FilterTag extends StatelessWidget {
	final EdgeInsets margin;
	final String title;
  final bool selected;
  final Color selectedColor;
  final Color unselectedColor;
  final double width;
  final double height;
  final double borderRadius;

	FilterTag({@required this.title, this.margin = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), this.selected = false,
  this.selectedColor, this.unselectedColor, this.width = 100, this.height = 40, this.borderRadius = 20});
	

  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
			decoration: BoxDecoration(
        color: this.selected ? (selectedColor ?? Theme.of(context).accentColor) : (unselectedColor ?? Colors.grey[400]),
        borderRadius: BorderRadius.circular(borderRadius),
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
