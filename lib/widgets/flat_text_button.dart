import 'package:flutter/material.dart';


/// Shows a flat, rectangular button with text in the middle with no border.
class FlatTextButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final EdgeInsets padding;

  FlatTextButton({@required this.text, @required this.onPressed, this.padding = const EdgeInsets.all(8.0)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: FlatButton(
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).accentColor,
            fontSize: 15.0,
          ),
          textAlign: TextAlign.end,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
