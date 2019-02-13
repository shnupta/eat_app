import 'package:flutter/material.dart';

class StandardOutlinedIconButton extends StatelessWidget {
  final Icon icon;
  final Function onPressed;
  final Color borderColor;
  final Color backgroundColor;
  final Color splashColor;
  final EdgeInsets margin;
  final double width;

  StandardOutlinedIconButton({
    @required this.icon,
    @required this.onPressed,
    this.borderColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.splashColor = const Color(0xFFFF5757),
    this.margin = const EdgeInsets.all(8.0),
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
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
                      child: icon,
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