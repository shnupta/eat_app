import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:eat_app/blocs/authentication/authentication_state.dart';
import 'package:eat_app/blocs/authentication/authentication_event.dart';

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
        _user.sendEmailVerification();
        UserUpdateInfo updateInfo = UserUpdateInfo();
        updateInfo.displayName = event.fullName;
        _user.updateProfile(
          updateInfo
        );
        yield AuthenticationState.authenticated(_user);
      } catch (error) {
        yield AuthenticationState.failure(error.message);
      }
    } else if (event is AutoLoginEvent) {
      yield AuthenticationState.loading();

      try {
        final FirebaseUser _user = await _login('', '', true);
        if(_user != null) yield AuthenticationState.authenticated(_user);
        else yield AuthenticationState.unauthenticated();
      } catch (error) {
        yield AuthenticationState.failure(error.message);
      }
    } else if(event is LogoutEvent) {
      yield authState.copyWith(isLoading: true);

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
      user = _auth.currentUser();
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
    else {
      
      return _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    }
  }

  Future<void> _logout() {
    return _auth.signOut();
  }
}
