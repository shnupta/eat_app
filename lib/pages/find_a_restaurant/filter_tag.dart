import 'package:flutter/material.dart';

class FilterTag extends StatelessWidget {
	final EdgeInsets margin;
	final String title;

	FilterTag({@required this.title, this.margin = const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0)});
	

  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      margin: margin,
			decoration: BoxDecoration(
        color: Colors.grey[400],
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
