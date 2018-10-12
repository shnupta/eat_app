import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';


// A bloc is a state management method for separating business logic and presentation components within an app.
// This utilizes streams, which reflect the asynchronous nature of mobile apps. 

// The basics of a bloc are as follows:
// The presentation component will send Events via a dispatch method call. This Event is send to the bloc where
// it is either processed and/or sent to the backend (e.g. Firebase in my case). Firebase will then return
// an async response (which is why streams are used) back to the bloc. Blocs contain their own state, in the
// below code there is the AuthenticationState. This state can then be updated within the block and using the 
// mapEventToState, this state is then reflected in the presentation components (ui).


/// AuthenticationState has a few different statuses and properties that can be used within the app:
/// isLoading: this will be true when a login is occuring
/// isAuthenticateButtonEnabled: will turn false when a authentication event
/// is occuring to prevent multiple authentication attempts over the top of eachother

class AuthenticationState {
  final bool isLoading;
  final bool isAuthenticated;
  final String error;
  final bool isAuthenticateButtonEnabled;

  AuthenticationState({
    @required this.isLoading,
    @required this.isAuthenticated,
    @required this.error,
    @required this.isAuthenticateButtonEnabled
  });

  // This is the initial state for the AuthenticationBloc. Not loading, button enabled and no error or token.
  factory AuthenticationState.initial() {
    return AuthenticationState(
      isLoading: false,
      isAuthenticated: false,
      isAuthenticateButtonEnabled: true,
      error: '',
    );
  }

  // Returns the authentication state which represents that the login is now being processed.
  factory AuthenticationState.loading() {
    return AuthenticationState(
      isLoading: true,
      isAuthenticated: false,
      isAuthenticateButtonEnabled: false,
      error: '',
    );
  }

  // Returns a authentication state that indicates there was an error.
  factory AuthenticationState.failure(String error) {
    return AuthenticationState(
      isLoading: false,
      isAuthenticated: false,
      isAuthenticateButtonEnabled: true,
      error: error,
    );
  }

  // Returns a authentication state that indicates a successful login.
  factory AuthenticationState.success() {
    return AuthenticationState(
      isLoading: false,
      isAuthenticated: true,
      isAuthenticateButtonEnabled: true,
      error: '',
    );
  }
}

/// AuthenticationEvent represents a type of event that occurs which is related to the AuthenticationState and
/// AuthenticationBloc. There is not a generic LoginEvent and so this is why this class is abstract.
abstract class AuthenticationEvent {}


/// LoginButtonPressed is an event that is dispatched when the user attempts to signing. Verification that
/// the inputted email and password are of correct format and length will be done prior to this event being called.
class LoginButtonPressed extends AuthenticationEvent {
  final String email;
  final String password;

  LoginButtonPressed({
    @required this.email,
    @required this.password
  });
}

class SignupButtonPressed extends AuthenticationEvent {
  final String fullName;
  final String email;
  final String password;

  SignupButtonPressed({
    @required this.fullName,
    @required this.email,
    @required this.password
  });
}


/// The AuthenticationBloc is the final piece in the bloc method for the login function.
/// The AuthenticationBloc contains the authentication state and implements the onLoginButtonPressed method.
/// When this is called the LoginButtonPressed event is dispatched to the Bloc. This is then processed right away
/// (at the moment, before Firebase) and in mapEventToState, the event is processed and the state is updated which
/// is then reflected in the UI by moving to the home page, for example.
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationState get initialState => AuthenticationState.initial();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if(event is LoginButtonPressed) {
      yield AuthenticationState.loading();

      try {
        final login = await _login(event.email, event.password);
        yield AuthenticationState.success();
      } catch (error) {
        yield AuthenticationState.failure(error);
      }
    } else if (event is SignupButtonPressed) {
      yield AuthenticationState.loading();

      try {
        yield AuthenticationState.success();
      } catch(error) {
        yield AuthenticationState.failure(error);
      }
    }
  }

  void onLoginButtonPressed({@required String email, @required String password}) {
    dispatch(
      LoginButtonPressed(email: email, password: password )
    );
  }

  void onSignupButtonPressed({@required String fullName, @required String email, @required String password}) {
    dispatch(
      SignupButtonPressed(fullName: fullName, email: email, password: password)
    );
  }

  Future<bool> _login(String email, String password) {
    return Future.delayed(Duration(seconds: 1), () => true);
  }
}

