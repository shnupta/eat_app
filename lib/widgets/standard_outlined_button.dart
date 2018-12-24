import 'package:flutter/material.dart';

/// A button with a solid background colour and also a solid border colour.
class StandardOutlinedButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color borderColor;
  final Color backgroundColor;
  final Color splashColor;
  final EdgeInsets margin;

  StandardOutlinedButton({
    @required this.text,
    @required this.onPressed,
    this.borderColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.splashColor = const Color(0xFFFF5757),
    this.margin = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: margin,
      alignment: Alignment.center,
      child: Row(
        children: <Widget>[
          Expanded(
            child: OutlineButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              splashColor: splashColor,
              highlightedBorderColor: borderColor,
              onPressed: onPressed,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
