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
        home: _rootPage(),
      ),
    );
  }

  Widget _rootPage() {
    return BlocBuilder<AuthenticationEvent, AuthenticationState>(
      bloc: authBloc,
      builder: (BuildContext context, AuthenticationState authState) {
        List<Widget> _widgets = [];

        if (authState.isInitialising) {
          authBloc.onAutoLogin();
        }

        if (authState.isLoading) {
          _widgets.add(_loadingIndicator());
        }

        if (authState.isAuthenticated) {
          _widgets.add(HomePage());
        } else {
          _widgets.add(AuthPage());
        }
        
        return Stack(
          children: _widgets,
        );
      },
    );
  }

  ThemeData _createTheme() {
    return ThemeData(
      fontFamily: 'K2D',
    );
  }

  Widget _loadingIndicator() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.3,
          child: ModalBarrier(dismissible: false, color: Colors.grey),
        ),
        Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
}
}
