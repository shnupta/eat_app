import 'package:flutter/material.dart';

import 'package:snacc/blocs/news.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NewsBloc newsBloc = BlocProvider.of<NewsBloc>(context);

    return BlocBuilder(
      bloc: newsBloc,
      builder: (BuildContext context, NewsState newsState) {
        if(newsState.isInitialising) {
          newsBloc.loadNews();
          return Container();
        }

        if(newsState.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (newsState.articles != null) {
          return Scaffold(
            body: ListView(
              children: newsState.articles
                  .map((article) => ListTile(
                        title: Text(article.title),
                      ),)
                  .toList(),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text('No articles available'),
            ),
          );
        }
      },
    );
  }
}
