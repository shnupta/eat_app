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
  /// Returns the ID of the newly created document
  static String createDocumentAtCollection(String collectionPath, Map<String, dynamic> data) {
    DocumentReference doc = _firestore.collection(collectionPath).document();
    doc.setData(data);
    return doc.documentID;
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

  /// Converts [document] into a map. Takes [document.data] and merges it with [document.documentID] 
  /// to make one singular map of details needed.
  static Map<String, dynamic> _documentToMap(DocumentSnapshot document) {
    Map<String, dynamic> m = document.data;
    m['id'] = document.documentID;
    return m;
  }

  /// Reads and returns all documents inside the collection at [collectionPath]
  static Future<List<Map<String, dynamic>>> readDocumentsAtCollection(String collectionPath) async {
    QuerySnapshot snapshot = await _firestore.collection(collectionPath).getDocuments();
    List<DocumentSnapshot> documents = snapshot.documents;
    List<Map<String, dynamic>> data = documents.map((document) => _documentToMap(document)).toList();
    return Future.value(data);
  }


  /// Reads a maximum of [limit] documents from the collection at [collectionPath]
  static Future<List<Map<String, dynamic>>> readDocumentsAtCollectionWithLimit(String collectionPath, int limit) async {
    Query query = _firestore.collection(collectionPath).limit(limit);
    QuerySnapshot snapshot = await query.getDocuments();
    List<DocumentSnapshot> documents = snapshot.documents;
    List<Map<String, dynamic>> data = documents.map((document) => _documentToMap(document)).toList();
    return Future.value(data);
  }

  /// Reads a maximum of [limit] documents from the collection at [collectionPath] and orders them by
  /// their [timestamp] descending.
  static Future<List<Map<String, dynamic>>> readDocumentsAtCollectionWithLimitByTimestampDescending(String collectionPath, int limit) async {
    Query query = _firestore.collection(collectionPath).limit(limit);
    query = query.orderBy('timestamp', descending: true);
    QuerySnapshot snapshot = await query.getDocuments();
    List<DocumentSnapshot> documents = snapshot.documents;
    List<Map<String, dynamic>> data = documents.map((document) => _documentToMap(document)).toList();
    return Future.value(data);
  }

  /// Sets the timestamp field [timestampFieldName] of the document with [documentID] in the collection 
  /// at [collectionPath] to update to now.
  static void setDocumentTimestampNowWithIDAtCollection(String collectionPath, String documentID, String timestampFieldName) {
    _firestore.collection(collectionPath).document(documentID).setData({
      timestampFieldName: Timestamp.now(),
    }, merge: true);
  }
}
