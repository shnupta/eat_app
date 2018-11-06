import 'package:cloud_firestore/cloud_firestore.dart';

/// I've written this Database class as the sole way to communicate with the Firebase Cloud Firestore
/// backend. All read, writes, listening events etc. will traverse through this class.
/// 
/// I think pretty much all of the methods will be static as there isn't a need to initialise a database
/// anywhere. It won't actually hold any data. It will just send and retrieve.
class Database {
  /// The reference to the default Firebase app
  static Firestore _firestore = Firestore.instance;

  /// Creates a new document in the path specified by [collectionPath]
  static void createDocumentAtCollection(String collectionPath, Map<String, dynamic> data) {
    _firestore.collection(collectionPath).document().setData(data);
  }

  /// Creates a new document with the provided [documentID] at the [collectionPath]
  /// If a document with [documentID] already exists it will be overwritten.
  static void createDocumentWithIDAtCollection(String collectionPath, String documentID, Map<String, dynamic> data) {
    _firestore.collection(collectionPath).document(documentID).setData(data);
  }


  /// Creates a new document with the provided [documentID] at the [collectionPath]
  /// If a document with [documentID] already exists it will be merged with the [data] provided.
  static void mergeDocumentWithIDAtCollection(String collectionPath, String documentID, Map<String, dynamic> data) {
    _firestore.collection(collectionPath).document(documentID).setData(data, merge: true);
  }
}