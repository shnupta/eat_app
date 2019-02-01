import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

/// The [ConfigLoader] is a class that loads API keys and other secrets from a file
/// not publicly available. This means that my keys and secrets are secure.
class ConfigLoader {
  Map<String, String> keys;

  /// The location of the keys JSON file
  final String fileLocation = 'config/keys.json';

  ConfigLoader() {
    keys = Map();
  }

  /// Load all of the api keys from the file
  Future<void> loadKeys() async {
    String jsonString = await rootBundle.loadString(fileLocation);
    json.decode(jsonString, reviver: (key, value) {
      keys[key.toString()] = value.toString();
    });
  }

  // Allow keys to be accessed using [] and the key name
  operator [](String key) => keys[key];
}