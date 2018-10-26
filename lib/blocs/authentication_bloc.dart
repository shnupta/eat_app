import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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
  final FirebaseUser user;
  final bool isLoading;
  final bool isAuthenticated;
  final String error;
  final bool isInitialising;

  AuthenticationState(
      {@required this.isLoading,
      @required this.isAuthenticated,
      @required this.error,
      @required this.isInitialising,
      this.user});

  // This is the initial state for the AuthenticationBloc. Not loading, button enabled and no error or token.
  factory AuthenticationState.initialising() {
    return AuthenticationState(
      isLoading: false,
      isAuthenticated: false,
      isInitialising: true,
      error: '',
    );
  }

  // Returns the authentication state which represents that the login is now being processed.
  factory AuthenticationState.loading() {
    return AuthenticationState(
      isLoading: true,
      isAuthenticated: false,
      isInitialising: false,
      error: '',
    );
  }

  // Returns a authentication state that indicates there was an error.
  factory AuthenticationState.failure(String error) {
    return AuthenticationState(
      isLoading: false,
      isAuthenticated: false,
      isInitialising: false,
      error: error,
    );
  }

  // Returns a authentication state that indicates a successful login.
  factory AuthenticationState.authenticated(FirebaseUser _user) {
    return AuthenticationState(
      user: _user,
      isLoading: false,
      isAuthenticated: true,
      isInitialising: false,
      error: '',
    );
  }

  // Returns a authentication state that indicates no user is logged in
  factory AuthenticationState.unauthenticated() {
    return AuthenticationState(
      isLoading: false,
      isAuthenticated: false,
      isInitialising: false,
      error: '',
    );
  }
}

/// AuthenticationEvent represents a type of event that occurs which is related to the AuthenticationState and
/// AuthenticationBloc. There is not a generic LoginEvent and so this is why this class is abstract.
abstract class AuthenticationEvent {}

/// LoginButtonPressed is an event that is dispatched when the user attempts to signing. Verification that
/// the inputted email and password are of correct format and length will be done prior to this event being called.
class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  LoginEvent({@required this.email, @required this.password});
}

class SignupEvent extends AuthenticationEvent {
  final String fullName;
  final String email;
  final String password;
  final String passwordRepeated;

  SignupEvent(
      {@required this.fullName, @required this.email, @required this.password, @required this.passwordRepeated});
}

class AutoLoginEvent extends AuthenticationEvent {}

class LogoutEvent extends AuthenticationEvent {}

/// The AuthenticationBloc is the final piece in the bloc method for the login function.
/// The AuthenticationBloc contains the authentication state and implements the onLoginButtonPressed method.
/// When this is called the LoginButtonPressed event is dispatched to the Bloc. This is then processed right away
/// (at the moment, before Firebase) and in mapEventToState, the event is processed and the state is updated which
/// is then reflected in the UI by moving to the home page, for example.
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationState get initialState => AuthenticationState.initialising();

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationState authState, AuthenticationEvent event) async* {
    if (event is LoginEvent) {
      yield AuthenticationState.loading();

      try {
        final FirebaseUser _user = await _login(event.email, event.password);
        yield AuthenticationState.authenticated(_user);
      } catch (error) {
        yield AuthenticationState.failure(error.message);
      }
    } else if (event is SignupEvent) {
      yield AuthenticationState.loading();

      try {
        final FirebaseUser _user =
            await _signup(event.fullName, event.email, event.password, event.passwordRepeated);
        yield AuthenticationState.authenticated(_user);
      } catch (error) {
        yield AuthenticationState.failure(error.message);
      }
    } else if (event is AutoLoginEvent) {
      yield AuthenticationState.loading();

      try {
        final FirebaseUser _user = await _login('', '', true);
        yield AuthenticationState.authenticated(_user);
      } catch (error) {
        yield AuthenticationState.failure(error.message);
      }
    } else if(event is LogoutEvent) {
      yield AuthenticationState.loading();

      try {
        await _logout();
        yield AuthenticationState.unauthenticated();
      } catch(error) {
        yield AuthenticationState.failure(error.message);
      }
    }
  }

  void onLogin(
      {@required String email, @required String password}) {
    dispatch(LoginEvent(email: email, password: password));
  }

  void onSignup(
      {@required String fullName,
      @required String email,
      @required String password,
      @required String passwordRepeated}) {
    dispatch(SignupEvent(
        fullName: fullName, email: email, password: password, passwordRepeated: passwordRepeated));
  }

  void onLogout() {
    dispatch(LogoutEvent());
  }

  void onAutoLogin() {
    dispatch(AutoLoginEvent());
  }

  Future<FirebaseUser> _login(String email, String password,
      [bool autoLogin = false]) async {

    Future<FirebaseUser> user;
    if (autoLogin) {
      if (await _auth.currentUser() != null) user = _auth.currentUser();
    } else if (email == '')
      throw Exception('Email is empty');
    else if (password == '') throw Exception('Password is empty');
    else user = _auth.signInWithEmailAndPassword(email: email, password: password);

    return user;
  }

  Future<FirebaseUser> _signup(String fullName, String email, String password, String passwordRepeated) {
    if (fullName == '')
      throw Exception('Full name is empty');
    else if (email == '')
      throw Exception('Email is empty');
    else if (password == '') throw Exception('Password is empty');
    else if(passwordRepeated == '') throw Exception('Repeated password is empty');
    else if(password != passwordRepeated) throw Exception('Passwords do not match');
    else return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> _logout() {
    return _auth.signOut();
  }
}
