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

  factory NewsState.initialising() {
    return NewsState(
      articles: null,
      isLoading: false,
      isInitialising: true,
      error: '',
    );
  }

  factory NewsState.loading() {
    return NewsState(
      articles: null,
      isLoading: true,
      isInitialising: false,
      error: '',
    );
  }

  factory NewsState.normal(List<NewsArticle> articles) {
    return NewsState(
      articles: articles,
      isLoading: false,
      isInitialising: false,
      error: '',
    );
  }

  factory NewsState.failure(String error) {
    return NewsState(
      articles: null,
      isLoading: false,
      isInitialising: false,
      error: error,
    );
  }
}
