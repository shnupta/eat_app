import 'package:flutter/material.dart';

import 'package:eat_app/widgets/normal_text_input.dart';
import 'package:eat_app/widgets/standard_filled_button.dart';
import 'package:eat_app/widgets/standard_outlined_button.dart';
import 'package:eat_app/widgets/flat_text_button.dart';

import 'package:eat_app/blocs/login_bloc.dart';

import 'package:eat_app/pages/home_page.dart';

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
class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  // This page controller allows me to control a PageView so I can
  // set things such as the default page and how the PageView moves.
  PageController _pageController = PageController(
    initialPage: 1,
    viewportFraction: 1.0,
  );

  // Login page text editing controllers
  TextEditingController _loginEmailTextEditingController =
      TextEditingController();
  TextEditingController _loginPasswordTextEditingController =
      TextEditingController();

  // Signup page text editing controllers
  TextEditingController _signupNameTextEditingController =
      TextEditingController();
  TextEditingController _signupEmailTextEditingController =
      TextEditingController();
  TextEditingController _signupPasswordTextEditingController =
      TextEditingController();
  TextEditingController _signupRepeatPasswordTextEditingController =
      TextEditingController();

  final LoginBloc loginBloc = LoginBloc();

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
            _buildLoginPage(),
            _buildAuthHomePage(), // Landing splash screen, app title and logo, login and signup buttons
            _buildSignupPage(),
          ],
          onPageChanged: (int page) {
            if (page == 1) FocusScope.of(context).requestFocus(FocusNode());
          },
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Widget _buildLoginPage() {
    return BlocBuilder<LoginState>(
      bloc: loginBloc,
      builder: (BuildContext context, LoginState loginState) {
        if (loginState.token.isNotEmpty) {
          return Navigator(
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute(
                builder: (BuildContext context) => HomePage(),
              );
            },
          );
        }

        if (loginState.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(120.0),
                child: Center(
                  child: Icon(
                    Icons.fastfood,
                    color: Colors.redAccent,
                    size: 50.0,
                  ),
                ),
              ),
              NormalTextInput(
                title: 'EMAIL',
                hintText: 'Enter your email...',
                textEditingController: _loginEmailTextEditingController,
              ),
              Divider(
                height: 24.0,
              ),
              NormalTextInput(
                title: 'PASSWORD',
                hintText: 'Enter your password...',
                obscureText: true,
                textEditingController: _loginPasswordTextEditingController,
              ),
              Divider(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatTextButton(
                    text: 'Forgot your password?',
                    onPressed: () => null,
                    padding: EdgeInsets.only(right: 20.0),
                  ),
                ],
              ),
              StandardFilledButton(
                onPressed: _onLoginButtonPressed,
                text: 'LOG IN',
                margin: EdgeInsets.only(
                    left: 30.0, right: 30.0, top: 30.0, bottom: 10.0),
              ),
            ],
          ),
        );
      },
    );
  }

  _onLoginButtonPressed() {
    loginBloc.onLoginButtonPressed(
        email: _loginEmailTextEditingController.text,
        password: _loginPasswordTextEditingController.text);
  }

  Widget _buildAuthHomePage() {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 60.0),
                  Container(
                    child: Text(
                      'EAT',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 80.0,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      'app',
                      style: TextStyle(
                        fontSize: 50.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  StandardOutlinedButton(
                    text: 'LOG IN',
                    onPressed: _gotoLoginPage,
                    margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 80.0),
                  ),
                  StandardFilledButton(
                    margin: EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 30.0, bottom: 10.0),
                    text: 'SIGN UP',
                    onPressed: _gotoSignupPage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupPage() {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 120.0, vertical: 40.0),
            child: Center(
              child: Icon(
                Icons.open_in_browser,
                color: Colors.redAccent,
                size: 50.0,
              ),
            ),
          ),
          NormalTextInput(
            title: 'FULL NAME',
            textEditingController: _signupNameTextEditingController,
            hintText: 'Enter your full name...',
          ),
          Divider(
            height: 24.0,
          ),
          NormalTextInput(
            title: 'EMAIL',
            textEditingController: _signupEmailTextEditingController,
            hintText: 'Enter your email...',
          ),
          Divider(
            height: 24.0,
          ),
          NormalTextInput(
            title: 'PASSWORD',
            obscureText: true,
            textEditingController: _signupPasswordTextEditingController,
            hintText: 'Enter your password...',
          ),
          Divider(
            height: 24.0,
          ),
          NormalTextInput(
            title: 'REPEAT PASSWORD',
            hintText: 'Repeat your password...',
            obscureText: true,
            textEditingController: _signupRepeatPasswordTextEditingController,
          ),
          Divider(
            height: 24.0,
          ),
          StandardFilledButton(
            text: 'SIGN UP',
            onPressed: () => Navigator.of(context).pushNamed('/home'),
            margin: EdgeInsets.only(
                left: 30.0, right: 30.0, top: 30.0, bottom: 10.0),
          ),
        ],
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
