import 'package:flutter/material.dart';


/// A rounded button with a solid background colour and splash colour.
class StandardFilledButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color backgroundColor;
  final Color splashColor;
  final EdgeInsets margin;

  StandardFilledButton({
    @required this.text,
    @required this.onPressed,
    this.backgroundColor = const Color(0xFFFF5757),
    this.splashColor = Colors.white,
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
            child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: backgroundColor,
              splashColor: splashColor,
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
                            color: Colors.white, fontWeight: FontWeight.bold),
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
