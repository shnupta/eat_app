import 'package:flutter/material.dart';

import 'package:eat_app/blocs/authentication_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eat_app/widgets/normal_text_input.dart';
import 'package:eat_app/widgets/standard_filled_button.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  // Signup page text editing controllers
  TextEditingController _signupNameTextEditingController =
      TextEditingController();
  TextEditingController _signupEmailTextEditingController =
      TextEditingController();
  TextEditingController _signupPasswordTextEditingController =
      TextEditingController();
  TextEditingController _signupRepeatPasswordTextEditingController =
      TextEditingController();

  bool errorShown = true;

  AuthenticationBloc authBloc = AuthenticationBloc();

  @override
  Widget build(BuildContext context) {
    

    return BlocBuilder(
        bloc: authBloc,
        builder: (BuildContext context, AuthenticationState authState) {
          if (authState.isAuthenticated) {
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

          if (authState.error != '' && !errorShown) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Scaffold.of(context).showSnackBar(errorSnackBar(authState.error));
              errorShown = true;
            });
          }

          return Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: <Widget>[
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 120.0, vertical: 40.0),
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
                  textCapitalization: TextCapitalization.words,
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
                  textEditingController:
                      _signupRepeatPasswordTextEditingController,
                ),
                Divider(
                  height: 24.0,
                ),
                StandardFilledButton(
                  text: 'SIGN UP',
                  onPressed: () => _onSignupButtonPressed(authBloc),
                  margin: EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 30.0, bottom: 10.0),
                ),
              ],
            ),
          );
        });
  }

  _onSignupButtonPressed(AuthenticationBloc authBloc) {
    // if (_signupEmailTextEditingController.text == '' ||
    //     _signupPasswordTextEditingController.text == '' ||
    //     _signupNameTextEditingController.text == '' ||
    //     _signupRepeatPasswordTextEditingController.text == '') {
    //   Scaffold.of(context).showSnackBar(missingRequiredSnackBar);
    //   return;
    // } else if (_signupPasswordTextEditingController.text.length < 8) {
    //   Scaffold.of(context).showSnackBar(passwordShortSnackBar);
    //   return;
    // } else if (_signupPasswordTextEditingController.text !=
    //     _signupRepeatPasswordTextEditingController.text) {
    //   Scaffold.of(context).showSnackBar(passwordsNotMatchingSnackBar);
    //   return;
    // }

    authBloc.onSignup(
        fullName: _signupNameTextEditingController.text,
        email: _signupEmailTextEditingController.text,
        password: _signupPasswordTextEditingController.text,
        passwordRepeated: _signupRepeatPasswordTextEditingController.text);

    setState(() {
      errorShown = false;
    });
  }

  SnackBar errorSnackBar(String error) {
    return SnackBar(
      content: Text(error),
    );
  }
}
