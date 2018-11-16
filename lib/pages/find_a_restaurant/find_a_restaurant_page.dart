import 'package:flutter/material.dart';

import 'package:eat_app/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eat_app/blocs/find_a_restaurant.dart';

class FindARestaurantPage extends StatefulWidget {

	createState() => _FindARestaurantPageState();

}
class _FindARestaurantPageState extends State<FindARestaurantPage> with TickerProviderStateMixin {
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
                          hintText: 'Search for a restaurant...',
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
      return ListView(
        children: state.results
            .map((result) => ListTile(
                  title: Text(result.name),
                  subtitle: Text(result.description),
                ))
            .toList(),
      );
    } else if (!state.isLoading) {
      return Center(
        child: Text('Search for a restaurant above!'),
      );
    }
  }

  /// Builds the expanded filter menu if the state says it should be open, else
  /// returns an empty container.
  Widget _buildFilterMenu(FindARestaurantState state, BuildContext context) {
		print('rebuilding');
      return AnimatedSize(
				curve: Curves.easeOut,
				duration: Duration(milliseconds: 400),
				vsync: this,
					child: Container(
							height: (state.filterMenuOpen != null && state.filterMenuOpen) ? null : minimizedHeight,
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: Text(
                    'Category',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
								Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  height: 70.0,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: 75.0,
                        color: Colors.red,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.orange,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.green,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.red,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.orange,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.green,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.red,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.orange,
                      ),
                      Container(
                        width: 75.0,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(),
            Row(),
            Row(),
          ],
        ),

      ),);
    }
}
