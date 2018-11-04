import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';


/// Represents a user of the app.
/// 
/// Typically this is the logged in user and once logged in, will be part of the AuthenticationState that
/// runs through the app.
class User {
  String id;
  String fullName;
  String email;
  FirebaseUser firebaseUser;

  User({@required this.id, @required this.fullName, @required this.email, this.firebaseUser});

  /// Create a User from a FirebaseUser. Typically from the result of a signup or login event.
  factory User.fromFirebaseUser(FirebaseUser user) {
    return User(
      id: user.uid,
      fullName: user.displayName,
      email: user.email,
      firebaseUser: user,
    );
  }

  /// Turns the User object into a map that can be used by the database to save to a user document.
  Map<String, dynamic> toMap() {
    return 
    {
      'id': this.id,
      'fullName': this.fullName,
      'email': this.email,
    };
  }
}