import 'package:flutter/material.dart';

import 'package:eat_app/pages/login_page.dart';
import 'package:eat_app/pages/signup_page.dart';
import 'package:eat_app/pages/auth_home_page.dart';

/// The AuthPage class is a page that will display three screens. A
/// auth page landing, a login page and a signup page. It is a
/// stateful widget so contains data about itself.
class AuthPage extends StatelessWidget {
  final autoLogin;

  AuthPage({this.autoLogin = false});

  // This page controller allows me to control a PageView so I can
  // set things such as the default page and how the PageView moves.
  final PageController _pageController = PageController(
    initialPage: 1,
    viewportFraction: 1.0,
  );

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
        child: PageView(
          controller: _pageController,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            // change these to their own widgets
            LoginPage(),
            AuthHomePage(
                gotoLoginPage: _gotoLoginPage,
                gotoSignupPage: _gotoSignupPage,
              ), // Landing splash screen, app title and logo, login and signup buttons
            SignupPage(),
          ],
          onPageChanged: (int page) {
            if (page == 1)
              FocusScope.of(context)
                  .requestFocus(FocusNode()); // hides the keyboard
          },
          scrollDirection: Axis.horizontal,
        ),
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
