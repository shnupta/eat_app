import 'package:flutter/material.dart';

import 'package:eat_app/widgets.dart';


/// The centre page of the 3 page auth system. Contains the app name and logo and the two buttons to navigate
/// to the signup and login pages.
class AuthHomePage extends StatelessWidget {
  /// The function that causes the PageController to navigate to the login page
  final Function gotoLoginPage;
  /// The function that causes the PageController to navigate to the signup page
  final Function gotoSignupPage;

  AuthHomePage({@required this.gotoLoginPage, @required this.gotoSignupPage});


  @override
  Widget build(BuildContext context) {
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
                    text: 'SIGN UP',
                    onPressed: gotoSignupPage,
                    margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 80.0),
                  ),
                  StandardFilledButton(
                    margin: EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 30.0, bottom: 10.0),
                    text: 'LOG IN',
                    onPressed: gotoLoginPage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
