import 'package:flutter/material.dart';

/// Represents a singluar article that can be viewed via the news/offers on the home page.
class Article {
  /// ID of the document in firestore.
  final String id;
  /// Displayed as the large text of an article on the home page.
  final String title;
  /// Body of the text that will be previewed in the small article, entire text visible when clicked on.
  final String body;
  /// Timestamp of the time that the article was published.
  final DateTime timestamp;
  /// URL of the image for this article
  final String imageUrl;

  Article({@required this.title, @required this.body, @required this.timestamp, @required this.id, this.imageUrl});
}