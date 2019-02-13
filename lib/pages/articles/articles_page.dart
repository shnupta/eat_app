import 'package:flutter/material.dart';

import 'package:snacc/models.dart';

class ArticlePage extends StatelessWidget {
  final Article article;

  ArticlePage({@required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              child: Text(
                article.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              child: Text(
                article.body,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}