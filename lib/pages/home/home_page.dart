import 'package:flutter/material.dart';

import 'package:snacc/blocs/news.dart';

import 'package:snacc/models.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacc/pages/home/article_tile.dart';
import 'package:snacc/pages/articles/articles_page.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'dart:math';

List<IntSize> _createSizes(int count) {
  Random rnd = new Random();
  return new List.generate(count,
      (i) => new IntSize((rnd.nextInt(100) + 200), rnd.nextInt(100) + 200));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NewsBloc newsBloc = BlocProvider.of<NewsBloc>(context);

    return BlocBuilder(
      bloc: newsBloc,
      builder: (BuildContext context, NewsState newsState) {
        if (newsState.isInitialising) {
          newsBloc.loadNews();
          return Container();
        }

        if (newsState.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (newsState.articles != null) {
          List<IntSize> sizes = _createSizes(newsState.articles.length);
          return Scaffold(
              body: StaggeredGridView.countBuilder(
            itemCount: newsState.articles.length,
            crossAxisCount: 4,
            itemBuilder: (BuildContext contex, int index) {
              return GestureDetector(
                onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ArticlePage(article: newsState.articles[index]),
                      ),
                    ),
                child: ArticleTile(
                  article: newsState.articles[index],
                  index: index,
                  size: sizes[index],
                ),
              );
            },
            staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
          ));
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
