import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:eat_app/blocs/authentication/authentication_state.dart';
import 'package:eat_app/blocs/authentication/authentication_event.dart';

import 'package:eat_app/models.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

// A bloc is a state management method for separating business logic and presentation components within an app.
// This utilizes streams, which reflect the asynchronous nature of mobile apps.

// The basics of a bloc are as follows:
// The presentation component will send Events via a dispatch method call. This Event is send to the bloc where
// it is either processed and/or sent to the backend (e.g. Firebase in my case). Firebase will then return
// an async response (which is why streams are used) back to the bloc. Blocs contain their own state, in the
// below code there is the AuthenticationState. This state can then be updated within the block and using the
// mapEventToState, this state is then reflected in the presentation components (ui).

/// The AuthenticationBloc is the final piece in the bloc method for the login function.
/// The AuthenticationBloc contains the authentication state and implements the onLoginButtonPressed method.
/// When this is called the LoginButtonPressed event is dispatched to the Bloc. This is then processed right away
/// (at the moment, before Firebase) and in mapEventToState, the event is processed and the state is updated which
/// is then reflected in the UI by moving to the home page, for example.
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationState get initialState => AuthenticationState.initialising();

  /// When an event is dispatched, the bloc calls this method to allow me to transform that event and any
  /// parameters it may have, into a state that can be consumed by the rest of the app.
  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationState authState, AuthenticationEvent event) async* {
    
    if (event is LoginEvent) {
      // tell the app to react and show something to the user to indicate we are doing some work
      yield AuthenticationState.loading();

      try {
        final FirebaseUser _user = await _login(event.email, event.password);

        // check that the login succeeded
        if (_user != null) {
          if (!_user.isEmailVerified) // if they haven't verified their email yet they can't login
            yield AuthenticationState.information('Please verify your email.');
          else {
            User u = User.fromFirebaseUser(_user);
            u.updateLastLoginTime();
            yield AuthenticationState.authenticated(u); // change to the logged in state
          }
        } else yield AuthenticationState.unauthenticated(); // for some reason didn't authenticate with no error
      } catch (error) {
        yield AuthenticationState.failure(error.message);
      }
    } else if (event is SignupEvent) {
      yield AuthenticationState.loading();

      try {
        final FirebaseUser _user = await _signup(event.fullName, event.email,
            event.password, event.passwordRepeated);
        _user.sendEmailVerification(); // the user needs to verify their email before they can login

        // we need to update this firebase user's name
        UserUpdateInfo updateInfo = UserUpdateInfo();
        updateInfo.displayName = event.fullName;
        _user.updateProfile(updateInfo);

        // create my own user as this is what the database class uses to save to firebase
        User saveUser = User.fromFirebaseUser(_user); 
        saveUser.fullName = event.fullName;
        saveUser.saveUserToDatabase();

        yield AuthenticationState.information('Verify your email, then login.'); // not an error but information
      } catch (error) {
        yield AuthenticationState.failure(error.message);
      }
    } else if (event is AutoLoginEvent) { // occurs on intialisation so the user doesn't have to login every time
      yield AuthenticationState.loading();

      try {
        final FirebaseUser _user = await _login('', '', true);
        if (_user != null) {
          if (!_user.isEmailVerified) // same as with normal login
            yield AuthenticationState.information('Please verify your email.');
          else
            yield AuthenticationState.authenticated(User.fromFirebaseUser(_user));
        } else
          yield AuthenticationState.unauthenticated();
      } catch (error) {
        print(error.toString());
        yield AuthenticationState.failure(error.message);
      }
    } else if (event is LogoutEvent) {
      yield authState.copyWith(isLoading: true);

      try {
        await _logout();
        yield AuthenticationState.unauthenticated();
      } catch (error) {
        yield AuthenticationState.failure(error.message);
      }
    } else if (event is ForgotPasswordEvent) {
      yield AuthenticationState.loading();

      try {
        await _sendPasswordResetEmail(event.email);

        yield AuthenticationState.information(
            'Reset your password with the link in the email sent to you');
      } catch (error) {
        yield AuthenticationState.failure(error);
      }
    }
  }

  // this function just dispatches a login event, the details of the login are passed to this function
  /// Dispatch a [LoginEvent] with the related [email] and [password]
  void onLogin({@required String email, @required String password}) {
    dispatch(LoginEvent(email: email, password: password));
  }

  /// Dispatch a [SignupEvent] with the relevant details.
  void onSignup(
      {@required String fullName,
      @required String email,
      @required String password,
      @required String passwordRepeated}) {
    dispatch(SignupEvent(
        fullName: fullName,
        email: email,
        password: password,
        passwordRepeated: passwordRepeated));
  }

  /// Dispatch a [LogoutEvent]
  void onLogout() {
    dispatch(LogoutEvent());
  }

  /// Dispatch an [AutoLoginEvent]
  void onAutoLogin() {
    dispatch(AutoLoginEvent());
  }

  /// Dispatch a [ForgotPasswordEvent] with the user's [email]
  void onForgotPassword({@required String email}) {
    dispatch(ForgotPasswordEvent(email: email));
  }

  /// Tries to log a user in with the specified [email] and [password]
  /// If [autoLogin] is passed with a true value, then the function will attempt to just return the currently
  /// logged in user from the FirebaseAuth cache.
  Future<FirebaseUser> _login(String email, String password,
      [bool autoLogin = false]) async {
    Future<FirebaseUser> user;
    if (autoLogin) {
      user = _auth.currentUser();
    } else if (email == '')
      throw Exception('Email is empty');
    else if (password == '')
      throw Exception('Password is empty');
    else
      user = _auth.signInWithEmailAndPassword(email: email, password: password);

    return user;
  }

  /// Creates a new user on Firebase
  Future<FirebaseUser> _signup(
      String fullName, String email, String password, String passwordRepeated) {
    if (fullName == '')
      throw Exception('Full name is empty');
    else if (email == '')
      throw Exception('Email is empty');
    else if (password == '')
      throw Exception('Password is empty');
    else if (passwordRepeated == '')
      throw Exception('Repeated password is empty');
    else if (password != passwordRepeated)
      throw Exception('Passwords do not match');
    else {
      return _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    }
  }

  /// Logs out a user.
  Future<void> _logout() {
    return _auth.signOut();
  }

  /// When a user has forgotten their email, this is called and Firebase will send a link to reset their password.
  Future<void> _sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }
}
