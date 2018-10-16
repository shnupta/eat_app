import 'package:flutter/material.dart';

import 'package:eat_app/blocs/authentication_bloc.dart';

import 'package:bloc/bloc.dart';

import 'package:eat_app/widgets/standard_outlined_button.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {

  AuthenticationBloc authBloc;

  @override
  Widget build(BuildContext context) {
    authBloc = BlocProvider.of(context) as AuthenticationBloc;

    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: BlocBuilder<AuthenticationEvent, AuthenticationState>(
        bloc: authBloc,
        builder: (BuildContext context, AuthenticationState authState) {
          // if(!authState.isAuthenticated) {
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     Navigator.of(context).pushNamed('/false');
          //   });
          // }
          return Container(
            width: MediaQuery.of(context).size.width,
            child: StandardOutlinedButton(
              text: 'LOGOUT',
              onPressed: _onLogoutButtonPressed,
            ),
          );
        },
      ),
    );
  }

  _onLogoutButtonPressed() {
    authBloc.logout();
  }
}
