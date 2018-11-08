import 'package:eat_app/blocs/news/news_event.dart';
import 'package:eat_app/blocs/news/news_state.dart';

import 'package:eat_app/models.dart';
import 'package:eat_app/database.dart';

import 'package:bloc/bloc.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {

  String _newsCollectionPath = 'news';

  NewsState get initialState => NewsState.initialising();

  @override Stream<NewsState> mapEventToState(NewsState state, NewsEvent event) async* {
    if(event is LoadNewsEvent) {
      yield NewsState.loading();

      try {
        List<Map<String, dynamic>> documents = await Database.readDocumentsAtCollection(_newsCollectionPath);
        yield NewsState.normal(documents.map((map) => NewsArticle.fromMap(map)).toList());
      } catch(error) {
        yield NewsState.failure(error.message);
      }
      
    }
  }

  void initialise() {
    dispatch(LoadNewsEvent());
  }
}