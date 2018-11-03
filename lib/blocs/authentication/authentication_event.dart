import 'package:flutter/material.dart';


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

class ForgotPasswordEvent extends AuthenticationEvent {
  String email;

  ForgotPasswordEvent({@required this.email});
}