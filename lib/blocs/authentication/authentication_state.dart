import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  AuthenticationState copyWith({FirebaseUser user, bool isLoading, bool isAuthenticated, String error, bool isInitialising}) {
    return AuthenticationState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isInitialising: isInitialising ?? this.isInitialising,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

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
  factory AuthenticationState.loading({bool isAuthenticated = false}) {
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