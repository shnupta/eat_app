import 'package:eat_app/blocs/news/news_event.dart';
import 'package:eat_app/blocs/news/news_state.dart';

import 'package:eat_app/models.dart';
import 'package:eat_app/database.dart';

import 'package:bloc/bloc.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {

  String _newsCollectionPath = 'news';
  /// Stores the currently displayed documents
  List<NewsArticle> _articles;

  // The initial state is dependent on whether the bloc has already loaded some articles as we don't
  // want to reload every time the user navigates to the home page. Only if new data is present or if
  // nothing has been loaded yet.
  NewsState get initialState {
    if(_articles != null) {
      return NewsState(
        articles: _articles,
        isInitialising: false,
        isLoading: false,
        error: '',
      );
    } else {
      return NewsState.initialising();
    }
  }

  @override Stream<NewsState> mapEventToState(NewsState state, NewsEvent event) async* {
    if(event is LoadNewsEvent) {
      yield NewsState.loading();

      try {
        List<Map<String, dynamic>> documents = await Database.readDocumentsAtCollectionWithLimitByTimestampDescending(_newsCollectionPath, 10);
        _articles = documents.map((map) => NewsArticle.fromMap(map)).toList();
        yield NewsState.normal(_articles);
      } catch(error) {
        yield NewsState.failure(error.message);
      }
      
    }
  }

  /// Dispatch a [LoadNewsEvent] to the bloc so that news articles are loaded from Firestore
  void loadNews() {
    dispatch(LoadNewsEvent());
  }
}