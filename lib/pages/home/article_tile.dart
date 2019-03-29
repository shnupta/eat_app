import 'package:flutter/material.dart';

import 'dart:ui';
import 'dart:math' as math;

import 'package:snacc/models.dart';

/// A cool little tile that displays and article, used on the home page
class ArticleTile extends StatelessWidget {
  final Article article;
  final int index;
  final IntSize size;
  final gradients = [
    [Color(0xFFC02425), Color(0xFFF0CB35)],
    [Color(0xFF8E0E00), Color(0xFF1F1C18)],
    [Color(0xFFfc00ff), Color(0xff00dbde)],
    [Color(0x304352), Color(0xFFd7d2cc)],
    [Color(0xFF525252), Color(0xFF3d72b4)],
    [Color(0xFFF1F2B5), Color(0xFF135058)],
    [Color(0xFFFC354C), Color(0xFF0ABFBC)],
    [Color(0xFFFEAC5E), Color(0xFFC779D0), Color(0xFF4BC0C8)],
    [Color(0xFF43cea2), Color(0xFF185a9d)],
  ];

  ArticleTile(
      {@required this.article, @required this.index, @required this.size});

  @override
  Widget build(BuildContext context) {
    if (article.imageUrl != null) {
      return Container(
        height: size.height.toDouble(),
        width: size.width.toDouble(),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(article.imageUrl), 
              fit: BoxFit.cover,
              ),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.centerLeft,
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0), // blur values
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withAlpha(70),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 10.0),
              child: Text(
                article.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      );
    } else {
      return Container(
        height: size.height.toDouble(),
        width: size.width.toDouble(),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]),
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: gradients[math.Random().nextInt(gradients.length)],
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  article.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
