import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:eat_app/models/user.dart';


/// I've written this Database class as the sole way to communicate with the Firebase Cloud Firestore
/// backend. All read, writes, listening events etc. will traverse through this class.
/// 
/// I think pretty much all of the methods will be static as there isn't a need to initialise a database
/// anywhere. It won't actually hold any data. It will just send and retrieve.
class Database {
  /// The reference to the default Firebase app
  static Firestore _firestore = Firestore.instance;

  /// Path to the users collection in Firestore
  static String _usersCollectionPath = 'users';

  /// Will save [user] to the path 'users/<uid>' in the firestore.
  static void saveNewUser(User user) {
    _firestore.collection(_usersCollectionPath).document(user.id).setData(user.toMap());
  }
}