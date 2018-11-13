import 'package:flutter/material.dart';

import 'package:eat_app/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eat_app/blocs/find_a_restaurant.dart';

class FindARestaurantPage extends StatelessWidget {
  final TextEditingController _searchInputTextEditingController =
      TextEditingController();

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
														if(!text.isEmpty) findARestaurantBloc
                              .search(_searchInputTextEditingController.text);
														else findARestaurantBloc.clearResults();
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
                          onPressed: () => null,
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
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

  Widget _buildResultsView(FindARestaurantState state) {
    if (state.results != null) {
			if(state.results.length == 0) return Center(child: Text('No matches'));
      return ListView(
        children: state.results
            .map((result) => ListTile(
                  title: Text(result.name),
                ))
            .toList(),
      );
    } else if (state.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: Text('Search for a restaurant above!'),
      );
    }
  }
}
