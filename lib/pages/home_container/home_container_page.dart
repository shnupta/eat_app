import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:snacc/pages/home.dart';
import 'package:snacc/pages/settings.dart';
import 'package:snacc/pages/find_a_restaurant.dart';
import 'package:snacc/pages/vouchers.dart';

import 'package:snacc/blocs/news.dart';
import 'package:snacc/blocs/find_a_restaurant.dart';
import 'package:snacc/blocs/vouchers.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

// This page will be responsible for initialising the blocs that will be needed by child pages.
// It will also act as a kind of container around all the other pages that can be visited when
// a user is logged in.

class HomeContainerPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeContainerPageState();
  }
}

class _HomeContainerPageState extends State<HomeContainerPage> {
  NewsBloc newsBloc = NewsBloc();
  FindARestaurantBloc findARestaurantBloc = FindARestaurantBloc();
  VouchersBloc vouchersBloc = VouchersBloc();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: <Widget>[
            BlocProvider(
              bloc: newsBloc,
              child: HomePage(),
            ),
            BlocProvider(
              bloc: findARestaurantBloc,
              child: FindARestaurantPage(),
            ),
            BlocProvider(
              bloc: vouchersBloc,
              child: VouchersPage(),
            ),
            SettingsPage(),
          ],
        ),
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          title: TabBar(
            indicatorWeight: 4.0,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Theme.of(context).accentColor,
            labelColor: Theme.of(context).accentColor,
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
