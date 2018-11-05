import 'package:flutter/material.dart';

/// Represents a singluar article that can be viewed via the news/offers on the home page.
class Article {
  /// Displayed as the large text of an article on the home page.
  final String title;
  /// Body of the text that will be previewed in the small article, entire text visible when clicked on.
  final String body;
  /// Timestamp of the time that the article was published.
  final DateTime timestamp;

  Article({@required this.title, @required this.body, @required this.timestamp});
}