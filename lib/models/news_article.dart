import 'package:flutter/material.dart';

import 'package:snacc/models.dart';

/// A [NewsArticle] is a type of article that is typically an update from the app to users.
/// However, it could be a notice from a restaurant.
/// 
/// It will not directly link to a current offer that is available.
class NewsArticle extends Article {
  /// Name of the author of the article.
  final String author;

  NewsArticle({@required title, @required body, @required timestamp, @required this.author, @required id})
  : super(title: title, body: body, timestamp: timestamp, id: id,);


  /// Constructs a [NewsArticle] from [map].
  /// 
  /// [map] should contain all the details necessary to contrust a [NewsArticle], such as id, title etc.
  factory NewsArticle.fromMap(Map<String, dynamic> map) {
    return NewsArticle(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      timestamp: map['timestamp'],
      author: map['author'],
    );
  }

}