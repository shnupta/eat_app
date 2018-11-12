import 'package:flutter/material.dart';

import 'package:eat_app/widgets.dart';

import 'package:eat_app/algolia/algolia_api.dart';

class FindARestaurantPage extends StatelessWidget {
  final TextEditingController _searchInputTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                    child: SearchInput(
                      margin: EdgeInsets.only(top: 10.0, left: 10.0),
                      textEditingController: _searchInputTextEditingController,
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
                      onPressed: () {
												AlgoliaClient client = AlgoliaClient(appID: '1JUPZEJV71', searchKey: 'fdba16a946692e6ff2c30fc5d672203b');
												AlgoliaIndex index = client.initIndex('restaurants_search');
												index.search(_searchInputTextEditingController.text);
											},
                    ),
                  ),
                )
              ],
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
