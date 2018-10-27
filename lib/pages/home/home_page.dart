import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:eat_app/blocs/authentication/authentication.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eat_app/widgets/widgets.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc  = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      body: BlocBuilder<AuthenticationEvent, AuthenticationState>(
        bloc: authBloc,
        builder: (BuildContext context, AuthenticationState authState) {
          return Container(
            width: MediaQuery.of(context).size.width,
            child: StandardFilledButton(
              text: 'LOGOUT',
              onPressed: () => _onLogoutButtonPressed(authBloc),
            ),
          );
        },
      ),
      //appBar: AppBar(),
      // drawer: Drawer(
      //   child: SingleChildScrollView(
      //     child: Column(
      //       children: <Widget>[
      //         ListTile(
      //           title: Text('Home'),
      //           trailing: Icon(Icons.home),
      //         ),
      //         ListTile(
      //           title: Text('Find a restaurant'),
      //           trailing: Icon(Icons.search),
      //         ),
      //         ListTile(
      //           title: Text('My vouchers'),
      //           trailing: Icon(Icons.receipt),
      //         ),
      //         ListTile(
      //           title: Text('Settings'),
      //           trailing: Icon(Icons.settings),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      bottomNavigationBar: CupertinoTabBar(
        //type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        //fixedColor: Colors.redAccent,
        activeColor: Colors.redAccent,
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            title: Text('Home', softWrap: true,),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text('Find a restaurant'),
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            title: Text('My vouchers'),
            icon: Icon(Icons.receipt),
          ),
          BottomNavigationBarItem(
            title: Text('Settings'),
            icon: Icon(Icons.settings),
          ),
        ],
      ),
    );
  }

  _onLogoutButtonPressed(AuthenticationBloc authBloc) {
    authBloc.onLogout();
  }
}
