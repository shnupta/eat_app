import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:snacc/models.dart';

class ArticleTile extends StatelessWidget {
  final Article article;
  final int index;
  final IntSize size;

  ArticleTile({@required this.article, @required this.index, @required this.size});

  @override
  Widget build(BuildContext context) {
    if (article.imageUrl != null) {
      return Container(
        height: size.height.toDouble(),
        width: size.width.toDouble(),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(article.imageUrl), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10.0),
                  color: Colors.black.withAlpha(70),
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
            ),
          ],
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
