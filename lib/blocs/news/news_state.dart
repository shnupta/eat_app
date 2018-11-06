import 'package:flutter/material.dart';

import 'package:eat_app/models.dart';

class NewsState {
  final bool isLoading;
  final bool isInitialising;
  final String error;
  final List<NewsArticle> articles;

  NewsState(
      {@required this.isLoading,
      @required this.isInitialising,
      @required this.error,
      @required this.articles});
}
