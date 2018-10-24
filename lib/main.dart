import 'package:flutter/material.dart';

import 'package:eat_app/pages/auth_page.dart';
import 'package:eat_app/pages/home_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eat_app/blocs/authentication_bloc.dart';

import 'package:flutter/services.dart';

void main() {
  AuthenticationBloc authBloc = AuthenticationBloc();
  runApp(new MyApp(authBloc));
}

class MyApp extends StatelessWidget {
  final AuthenticationBloc authBloc;

  MyApp(this.authBloc);

  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return BlocProvider(
      bloc: authBloc,
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _createTheme(),
        title: 'eat_app',
        initialRoute: '/true',
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/home': (BuildContext context) => BlocBuilder(builder: (context, state) => HomePage(), bloc: authBloc),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> elements = settings.name
              .split('/'); // Replace this with my custom list type eventually
          if (elements[0] != '') return null;

          if (elements[1] == 'true' || elements[1] == 'false') {
            return MaterialPageRoute(
              builder: (BuildContext context) =>
                  AuthPage(autoLogin: elements[1] == 'true' ? true : false),
            );
          }
        },
      ),
    );
  }

  ThemeData _createTheme() {
    return ThemeData(
      fontFamily: 'K2D',
    );
  }
}
