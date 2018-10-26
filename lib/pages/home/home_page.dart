import 'package:flutter/material.dart';

import 'package:eat_app/blocs/authentication/authentication.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eat_app/widgets/standard_outlined_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc  = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: BlocBuilder<AuthenticationEvent, AuthenticationState>(
        bloc: authBloc,
        builder: (BuildContext context, AuthenticationState authState) {
          if(authState.isAuthenticated) {
            print(authState.user.toString());
          }
          
          return Container(
            width: MediaQuery.of(context).size.width,
            child: StandardOutlinedButton(
              text: 'LOGOUT',
              onPressed: () => _onLogoutButtonPressed(authBloc),
            ),
          );
        },
      ),
    );
  }

  _onLogoutButtonPressed(AuthenticationBloc authBloc) {
    authBloc.onLogout();
  }
}
