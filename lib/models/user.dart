import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:eat_app/database.dart';


/// Represents a user of the app.
/// 
/// Typically this is the logged in user and once logged in, will be part of the AuthenticationState that
/// runs through the app.
class User {
  /// Firebase [uid] of the currently signed up/logged in user
  String id;
  /// Full name of the user. First set when they sign up.
  String fullName;
  /// Email that the user signed up with.
  String email;
  /// For certain cases it may be useful to store the [FirebaseUser] object to save retrieving it from 
  /// auth every time.
  FirebaseUser firebaseUser;

  /// Path to the users collection in Firestore
  static String _usersCollectionPath = 'users';

  User({@required this.id, @required this.fullName, @required this.email, this.firebaseUser});

  /// Create a [User] from a FirebaseUser [user]. Typically from the result of a signup or login event.
  factory User.fromFirebaseUser(FirebaseUser user) {
    return User(
      id: user.uid,
      fullName: user.displayName,
      email: user.email,
      firebaseUser: user,
    );
  }

  /// Saves the details of a user to the database at the path 'users/userID'
  /// 
  /// If this is a new user then their details will be written as normal.
  /// If the user already exists their details will be merged with the existing document on Firestore.
  void saveUserToDatabase() {
    Database.mergeDocumentWithIDAtCollection(_usersCollectionPath, this.id, this.toMap());
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