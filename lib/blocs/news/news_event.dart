import 'package:flutter/material.dart';

/// Base class that our events will extend from. This allows us to be generic inside the bloc.
abstract class NewsEvent {}

/// Dispatch this event to cause the bloc to load some news from the database which will then map 
/// to a state that the HomePage can consume.
class LoadNewsEvent extends NewsEvent {}


/// When a user clicks on a news article this event should be dispatched. With it will be the required
/// info needed to pass to the page that will display the entire news article.
class ViewNewsEvent extends NewsEvent {
  final String articleID;

  ViewNewsEvent({@required this.articleID});
}

