import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';


class FilterMenu extends AnimatedWidget {
	Widget build(BuildContext context) {
      return AnimatedContainer(
					duration: Duration(milliseconds: 800),
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: Text(
                    'Category',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
								Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  height: 70.0,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: 75.0,
                        color: Colors.red,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.orange,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.green,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.red,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.orange,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.green,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.red,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.orange,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(),
            Row(),
            Row(),
          ],
        ),
      );
	}
}
