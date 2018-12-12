import 'package:flutter/material.dart';

import 'package:snacc/models.dart';

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

  /// This state is typical for when the HomePage has just been navigated to.
  factory NewsState.initialising() {
    return NewsState(
      articles: null,
      isLoading: false,
      isInitialising: true,
      error: '',
    );
  }

  /// Indicates that news articles are being loaded or other processing is occurring inside the bloc.
  factory NewsState.loading() {
    return NewsState(
      articles: null,
      isLoading: true,
      isInitialising: false,
      error: '',
    );
  }

  /// The normal state is where articles have been loaded and can now be displayed to the user.
  factory NewsState.normal(List<NewsArticle> articles) {
    return NewsState(
      articles: articles,
      isLoading: false,
      isInitialising: false,
      error: '',
    );
  }

  /// Represents a state where an error has occured when interacting with the news bloc.
  factory NewsState.failure(String error) {
    return NewsState(
      articles: null,
      isLoading: false,
      isInitialising: false,
      error: error,
    );
  }

  /// Copies the existing state with any changes that need to made being optional.
  NewsState copyWith({List<NewsArticle> articles, bool isLoading, bool isInitialising, String error}) {
    return NewsState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      isInitialising:  isInitialising ?? this.isInitialising,
      error: error ?? this.error,
    );
  }
}
