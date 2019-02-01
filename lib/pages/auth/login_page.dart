import 'package:flutter/material.dart';

import 'package:snacc/blocs/authentication.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:snacc/widgets.dart';

/// The login page contains the email and password text inputs and the login button.
class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  // Login page text editing controllers
  TextEditingController _loginEmailTextEditingController =
      TextEditingController();
  TextEditingController _loginPasswordTextEditingController =
      TextEditingController();

  TextEditingController _forgotPasswordTextEditingController =
      TextEditingController();

  bool errorShown = true;

  bool infoShown = true;

  AuthenticationBloc authBloc;

  @override
  Widget build(BuildContext context) {
    authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocBuilder(
      bloc: authBloc,
      builder: (BuildContext context, AuthenticationState authState) {
        // If there is an error show it
        if (authState.error != '' && !errorShown) {
          // After the page has finished building, show a snackbar at the bottom indicating the error
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Scaffold.of(context).showSnackBar(errorSnackBar(authState.error));
            errorShown = true;
          });
        }

        // same as with the error
        if (authState.info != '' && !infoShown) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Scaffold.of(context).showSnackBar(errorSnackBar(authState.info));
            infoShown = true;
          });
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
                    color: Theme.of(context).accentColor,
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
                    onPressed: () =>
                        _onForgotPasswordButtonPressed(authBloc, context),
                    padding: EdgeInsets.only(right: 20.0),
                  ),
                ],
              ),
              StandardFilledButton(
                // only allow the button to trigger the button press function is the state says it should
                // be enabled
                onPressed: () => _onLoginButtonPressed(authBloc),
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

  _onLoginButtonPressed(AuthenticationBloc authBloc) {
    // Pass the entered details to the auth bloc which will then cause a LoginEvent to be dispatched
    authBloc.onLogin(
        email: _loginEmailTextEditingController.text,
        password: _loginPasswordTextEditingController.text);

    setState(() {
      errorShown = false;
      infoShown = false;
    });
  }

  _onForgotPasswordButtonPressed(
      AuthenticationBloc authBloc, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: Column(
                children: <Widget>[
                  NormalTextInput(
                    textEditingController: _forgotPasswordTextEditingController,
                    title: 'Email',
                    hintText: 'Enter your email...',
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: StandardFilledButton(
                      text: 'SEND RESET EMAIL',
                      onPressed: () {
                          _onForgotPasswordSendEmailButtonPressed(authBloc);
                          Navigator.of(context).pop();
                      }
                    ),
                  ),
                ],
              ),
            ),
          ]);
        });
  }

  _onForgotPasswordSendEmailButtonPressed(AuthenticationBloc authBloc) {
    authBloc.onForgotPassword(email: _forgotPasswordTextEditingController.text);

    setState(() {
      errorShown = false;
      infoShown = false;
    });
  }

  SnackBar errorSnackBar(String error) {
    return SnackBar(
      content: Text(error),
    );
  }
}
