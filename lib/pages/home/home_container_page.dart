import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:eat_app/pages/home/home_page.dart';
import 'package:eat_app/pages/settings/settings.dart';

class HomeContainerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: <Widget>[
            HomePage(),
            Container(),
            Container(),
            SettingsPage(),
          ],
        ),
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: TabBar(
            indicatorWeight: 4.0,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Colors.redAccent,
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.blueGrey[300],
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.search),
              ),
              Tab(
                icon: Icon(Icons.receipt),
              ),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
        ),
      ),
    );
  }
}
