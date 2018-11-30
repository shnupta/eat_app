import 'package:flutter/material.dart';

import 'package:eat_app/widgets.dart';
import 'package:eat_app/pages/find_a_restaurant/filter_menu.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eat_app/blocs/find_a_restaurant.dart';

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
                            if (!text.isEmpty)
                              findARestaurantBloc.search(
                                  _searchInputTextEditingController.text);
                            else
                              findARestaurantBloc.clearResults();
                          },
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
                        padding: const EdgeInsets.only(top: 5.0),
                        child: IconButton(
                          splashColor: Colors.redAccent,
                          padding: EdgeInsets.all(0.0),
                          icon: Icon(
                            Icons.filter_list,
                          ),
                          onPressed: () =>
                              findARestaurantBloc.toggleFilterMenu(),
                        ),
                      ),
                    )
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
              children: state.results
                  .map((result) => ListTile(
                        title: Text(result.name),
                        subtitle: Text(result.description),
                      ))
                  .toList(),
            ),
            CircularProgressIndicator(),
          ],
        );
      } else {
        return ListView(
          children: state.results
              .map((result) => ListTile(
                    title: Text(result.name),
                    subtitle: Text(result.description),
                  ))
              .toList(),
        );
      }
    } else if (!state.isLoading) {
      return Center(
        child: Text('Search above!'),
      );
    }
  }

  /// Builds the expanded filter menu if the state says it should be open, else
  /// returns an empty container.
  Widget _buildFilterMenu(FindARestaurantState state, BuildContext context) {
    return AnimatedSize(
      curve: Curves.easeOut,
      duration: Duration(milliseconds: 400),
      vsync: this,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 7.5, vertical: 10.0),
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
