import 'package:snacc/blocs/news/news_event.dart';
import 'package:snacc/blocs/news/news_state.dart';

import 'package:snacc/models.dart';
import 'package:snacc/database.dart';

import 'package:bloc/bloc.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {

  String _newsCollectionPath = 'news';
  /// Stores the currently displayed documents


  // The initial state is dependent on whether the bloc has already loaded some articles as we don't
  // want to reload every time the user navigates to the home page. Only if new data is present or if
  // nothing has been loaded yet.
  NewsState get initialState => NewsState.initialising();

  @override Stream<NewsState> mapEventToState(NewsState state, NewsEvent event) async* {
    if(event is LoadNewsEvent) {
      yield NewsState.loading();

      try {
        List<Map<String, dynamic>> documents = await Database.readDocumentsAtCollectionWithLimitByTimestampDescending(_newsCollectionPath, 10);
        List<Article> _articles = documents.map((map) => NewsArticle.fromMap(map)).toList();
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