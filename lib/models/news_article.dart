import 'package:flutter/material.dart';

import 'package:eat_app/models.dart';

/// A [NewsArticle] is a type of article that is typically an update from the app to users.
/// However, it could be a notice from a restaurant.
/// 
/// It will not directly link to a current offer that is available.
class NewsArticle extends Article {
  /// Name of the author of the article.
  final String author;

  NewsArticle({@required title, @required body, @required timestamp, @required this.author})
  : super(title: title, body: body, timestamp: timestamp);

  factory NewsArticle.fromMap(Map<String, dynamic> map) {
    return NewsArticle(
      title: map['title'],
      body: map['body'],
      timestamp: map['timestamp'],
      author: map['author'],
    );
  }

}