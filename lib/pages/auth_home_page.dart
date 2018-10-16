import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

import 'package:eat_app/widgets/standard_filled_button.dart';
import 'package:eat_app/widgets/standard_outlined_button.dart';

import 'package:eat_app/blocs/authentication_bloc.dart';

class AuthHomePage extends StatefulWidget {
  final Function gotoLoginPage;
  final Function gotoSignupPage;

  AuthHomePage({@required this.gotoLoginPage, @required this.gotoSignupPage});

  @override
  State<StatefulWidget> createState() {
    return _AuthHomePageState();
  }
}

class _AuthHomePageState extends State<AuthHomePage> {
  AuthenticationBloc authBloc;

  bool triedAutoLogin = false;

  @override
  Widget build(BuildContext context) {
    authBloc = BlocProvider.of(context) as AuthenticationBloc;

    return BlocBuilder(
        bloc: authBloc,
        builder: (BuildContext context, AuthenticationState authState) {
          // if (!authState.isAuthenticated && !triedAutoLogin) {
          //   authBloc.autoLogin();

          //   setState(() {
          //     triedAutoLogin = true;
          //   });
          // }

          // if (authState.isAuthenticated) {
          //   // We have to wait for the widgets to build before the Navigator can change pages, else Flutter
          //   // gets angry.
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     Navigator.of(context).pushNamed('/home');
          //   });
          // }

          // // show a loading indicator if the state has updated to indicate it is processing a login
          // if (authState.isLoading) {
          //   return Center(
          //     child: CircularProgressIndicator(),
          //   );
          // }

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
                          onPressed: widget.gotoSignupPage,
                          margin: EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 80.0),
                        ),
                        StandardFilledButton(
                          margin: EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 30.0, bottom: 10.0),
                          text: 'LOG IN',
                          onPressed: widget.gotoLoginPage,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
