import 'package:flutter/material.dart';

import 'package:eat_app/blocs/authentication_bloc.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eat_app/widgets/normal_text_input.dart';
import 'package:eat_app/widgets/standard_filled_button.dart';
import 'package:eat_app/widgets/flat_text_button.dart';

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

  bool errorShown = true;

  AuthenticationBloc authBloc;

  @override
  Widget build(BuildContext context) {
    authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocBuilder(
      bloc: authBloc,
      builder: (BuildContext context, AuthenticationState authState) {
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
    // Rather than do this, handle the errors based on the error state after the mapEventToState, same for signup
    // if (_loginEmailTextEditingController.text == '' ||
    //     _loginPasswordTextEditingController.text == '') {
    //   Scaffold.of(context).showSnackBar(missingRequiredSnackBar);
    //   return;
    // }

    authBloc.onLogin(
        email: _loginEmailTextEditingController.text,
        password: _loginPasswordTextEditingController.text);

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
