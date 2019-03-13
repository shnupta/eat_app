import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';

import 'package:snacc/widgets.dart';
import 'package:snacc/pages/find_a_restaurant/filter_menu.dart';
import 'package:snacc/pages/find_a_restaurant/result_tile.dart';
import 'package:snacc/pages/map_view.dart';
import 'package:snacc/pages/find_a_restaurant/favourite_restaurants_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacc/blocs/find_a_restaurant.dart';

class FindARestaurantPage extends StatefulWidget {
  createState() => _FindARestaurantPageState();
}

class _FindARestaurantPageState extends State<FindARestaurantPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchInputTextEditingController =
      TextEditingController();

  double minimizedHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    FindARestaurantBloc findARestaurantBloc =
        BlocProvider.of<FindARestaurantBloc>(context);

    return BlocBuilder(
      bloc: findARestaurantBloc,
      builder: (BuildContext context, FindARestaurantState state) {
        if (state.isInitialising) {
          findARestaurantBloc.initialise();
          return Container();
        }

        if (state.error.isNotEmpty) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(state.error),
                );
              },
            );
            findARestaurantBloc.errorShown();
          });
        }

        return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 7,
                      child: Container(
                        child: SearchInput(
                          onChanged: (text) {
                            findARestaurantBloc
                                .search(_searchInputTextEditingController.text);
                          },
                          trailing: GestureDetector(
                            child: Icon(
                              Icons.map,
                              color: Colors.green[700],
                            ),
                            onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MapViewPage()),
                                ),
                          ),
                          margin: EdgeInsets.only(top: 10.0, left: 10.0),
                          textEditingController:
                              _searchInputTextEditingController,
                          hintText: 'Restaurant, location or food type...',
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: IconButton(
                          splashColor: Theme.of(context).accentColor,
                          icon: Icon(
                            Icons.filter_list,
                          ),
                          onPressed: () =>
                              findARestaurantBloc.toggleFilterMenu(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.star,
                            color: Colors.yellow[800],
                          ),
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => FavouriteRestaurantsPage(),
                            )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  child: _buildFilterMenu(state, context),
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: _buildResultsView(state),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Contructs the ListView of results when they are preset. If no results are
  /// available then it displays the correct message.
  Widget _buildResultsView(FindARestaurantState state) {
    if (state.results != null) {
      if (state.results.length == 0) return Center(child: Text('No matches'));
      if (state.isLoading) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ListView(
              children:
                  state.results.map((result) => ResultTile(result)).toList(),
            ),
            CircularProgressIndicator(),
          ],
        );
      } else {
        return ListView(
          children: state.results
              .map(
                (result) => ResultTile(result),
              )
              .toList(),
        );
      }
    } else if (!state.isLoading) {
      return Center(
        child: Text('Search above!'),
      );
    } else
      return Center(child: Text('Initialising...'));
  }

  /// Builds the expanded filter menu if the state says it should be open, else
  /// returns an empty container.
  Widget _buildFilterMenu(FindARestaurantState state, BuildContext context) {
    return AnimatedSize(
      curve: Curves.easeOut,
      duration: Duration(milliseconds: 400),
      vsync: this,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 7.5, vertical: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Colors.grey[100],
        ),
        height: (state.filterMenuOpen != null && state.filterMenuOpen)
            ? null
            : minimizedHeight,
        child: FilterMenu(),
      ),
    );
  }
}
