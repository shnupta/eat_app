import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class ConfigLoader {
  Map<String, String> keys;

  final String fileLocation = 'config/keys.json';

  ConfigLoader() {
    keys = Map();
  }

  void loadKeys() async {
    String jsonString = await rootBundle.loadString(fileLocation);
    json.decode(jsonString, reviver: (key, value) {
      keys[key.toString()] = value.toString();
    });
  }
}