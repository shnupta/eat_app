import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

import 'package:snacc/pages/auth.dart';
import 'package:snacc/pages/home_container.dart';
import 'package:snacc/config.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacc/blocs/authentication.dart';

import 'package:flutter/services.dart';

void main() {
  // This is the authentication bloc that will persist throughout my whole app, it will be used
  // to perform authentication actions such as reauthenticate the user, login and logout in different parts of
  // the app.

  AuthenticationBloc authBloc = AuthenticationBloc();
  runApp(new MyApp(authBloc));
}

class MyApp extends StatelessWidget {
  final AuthenticationBloc authBloc;

  MyApp(this.authBloc);

  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]); // Only allow the device to be in portrait mode
    //SystemChrome.setEnabledSystemUIOverlays([]); // Hide notificaiton and navigation bars
    //debugPaintPointersEnabled = true;

    ConfigLoader configLoader = ConfigLoader();
    configLoader.loadKeys();

    return BlocProvider(
      // The BlocProvider, provides my authentication bloc to all children of this build context so that they
      // can inherit it and use it in their own methods
      bloc: authBloc,
      child: new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _createTheme(),
        title: 'snacc',
        home: _rootPage(),
      ),
    );
  }

  /// Determines which root page to show the user
  ///
  /// It is possible that the user is already logged in, if so, Firebase will have this user info cached
  /// and I can just send the user to the logged in page already after an AutoLogin event has been dispatched
  /// and processed by the auth bloc. Else I need to set the root page as the login/signup page.
  Widget _rootPage() {
    return BlocBuilder<AuthenticationEvent, AuthenticationState>(
      bloc: authBloc,
      builder: (BuildContext context, AuthenticationState authState) {
        List<Widget> _widgets = [];

        if (authState.isAuthenticated) {
          _widgets.add(HomeContainerPage());
        } else {
          _widgets.add(AuthPage());
        }

        if (authState.isInitialising) {
          authBloc.onAutoLogin();
        }

        if (authState.isLoading) {
          _widgets.add(_loadingIndicator());
        }

        // A stack does what it says on the tin, stacks widgets (or in my case entire pages) on top of eachother.
        return Stack(
          children: _widgets,
        );
      },
    );
  }

  ThemeData _createTheme() {
    return ThemeData(
      fontFamily: 'K2D',
      primaryColor: Color(0xFFFEAA2B),
      accentColor: Color(0xFFFF5757), //Color(0xFFe1e6e1),
      cursorColor: Color(0xFF2274a5),
      primaryColorDark: Color(0xFF0d0106),
    );
  }

  /// Shows a spinning, circular loading indicator with a slightly opaque grey background, over whatever is
  /// currently present on the screen
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
