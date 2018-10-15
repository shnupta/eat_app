import 'package:flutter/material.dart';

import 'package:eat_app/pages/login_page.dart';
import 'package:eat_app/pages/signup_page.dart';
import 'package:eat_app/pages/auth_home_page.dart';

import 'package:eat_app/blocs/authentication_bloc.dart';
import 'package:bloc/bloc.dart';

/// The AuthPage class is a page that will display three screens. A
/// auth page landing, a login page and a signup page. It is a
/// stateful widget so contains data about itself.
class AuthPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

/// This is the state (data) class for the auth page. This contains
/// all the variables, functions etc. that will be needed inside the
/// auth page.
class _AuthPageState extends State<AuthPage> {
  // This page controller allows me to control a PageView so I can
  // set things such as the default page and how the PageView moves.
  PageController _pageController = PageController(
    initialPage: 1,
    viewportFraction: 1.0,
  );

  AuthenticationBloc authBloc = AuthenticationBloc();

  bool triedAutoLogin = false;

  // The build method is required for any widget. This is what tells
  // Flutter, how it should render the content of my page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context)
            .size
            .height, // This queries the device to find out its screen information
        child: BlocBuilder<AuthenticationState>(
            bloc: authBloc,
            builder: (BuildContext context, AuthenticationState authState) {
              if (!authState.isAuthenticated && !triedAutoLogin) {
                authBloc.autoLogin();

                setState(() {
                  triedAutoLogin = true;
                });
              }

              if (authState.isAuthenticated) {
                // We have to wait for the widgets to build before the Navigator can change pages, else Flutter
                // gets angry.
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).pushNamed('/home');
                });
              }

              // show a loading indicator if the state has updated to indicate it is processing a login
              if (authState.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return PageView(
                controller: _pageController,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  // change these to their own widgets
                  LoginPage(),
                  AuthHomePage(gotoLoginPage: _gotoLoginPage, gotoSignupPage: _gotoSignupPage,), // Landing splash screen, app title and logo, login and signup buttons
                  SignupPage(),
                ],
                onPageChanged: (int page) {
                  if (page == 1)
                    FocusScope.of(context)
                        .requestFocus(FocusNode()); // hides the keyboard
                },
                scrollDirection: Axis.horizontal,
              );
            }),
      ),
    );
  }

  void _gotoLoginPage() {
    _pageController.animateToPage(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _gotoSignupPage() {
    _pageController.animateToPage(
      2,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
