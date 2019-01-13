import 'package:flutter/material.dart';

class Config extends InheritedModel<String> {
  final Map<String, String> keys;

  Config({this.keys, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(Config old) {
    return false;
  }

  @override
  bool updateShouldNotifyDependent(Config old, Set<String> aspects) {
    return false;
  }

  static Config of(BuildContext context) {
    return InheritedModel.inheritFrom<Config>(context);
  }

  operator [](String key) => keys[key];
}