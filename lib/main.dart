import 'package:flutter/material.dart';

import 'package:eat_app/pages/auth_page.dart';
import 'package:eat_app/pages/home_page.dart';

import 'package:bloc/bloc.dart';

import 'package:eat_app/blocs/authentication_bloc.dart';

import 'package:flutter/services.dart';

void main() { 
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      return _MyAppState();
    }
}

class _MyAppState extends State<MyApp> {

  AuthenticationBloc _authBloc = AuthenticationBloc();

  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _createTheme(),
      title: 'eat_app',
      initialRoute: '/true',
      routes: {
        '/': (BuildContext context) => BlocProvider(bloc: _authBloc, child: AuthPage()),
        '/home': (BuildContext context) => BlocProvider(bloc: _authBloc, child: HomePage()),
      },
      onGenerateRoute: (RouteSettings settings) {
        final List<String> elements = settings.name.split('/'); // Replace this with my custom list type eventually
        if(elements[0] != '') return null;

        if(elements[1] == 'true' || elements[1] == 'false') {
          return MaterialPageRoute(
            builder: (BuildContext context) => BlocProvider(bloc: _authBloc, child: AuthPage(autoLogin: elements[1] == 'true' ? true : false)),
          );
        }
      },
    );
  }

  ThemeData _createTheme() {
    return ThemeData(
      fontFamily: 'K2D',
    );
  }
}