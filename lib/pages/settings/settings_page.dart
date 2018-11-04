import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:eat_app/blocs/authentication.dart';

import 'package:eat_app/widgets.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);

    return BlocBuilder<AuthenticationEvent, AuthenticationState>(
      bloc: authBloc,
      builder: (BuildContext context, AuthenticationState authState) {
        return ListView(
          children: <Widget>[
            ListTile(
              title: StandardFilledButton(
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                text: 'LOGOUT',
                onPressed: () => _onLogoutButtonPressed(authBloc),
              ),
            ),
            Divider(),
          ],
        );
      },
    );
  }

  _onLogoutButtonPressed(AuthenticationBloc authBloc) {
    authBloc.onLogout();
  }
}
