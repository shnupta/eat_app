import 'package:flutter/material.dart';

import 'package:eat_app/pages/auth_page.dart';
import 'package:eat_app/pages/home_page.dart';

import 'package:flutter/services.dart';

void main() { 
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _createTheme(),
      title: 'eat_app',
      home: AuthPage(),
      routes: {
        //'/': (BuildContext context) => AuthPage(),
        '/home': (BuildContext context) => HomePage(),
      },
    );
  }

  ThemeData _createTheme() {
    return ThemeData(
      fontFamily: 'K2D',
    );
  }
}