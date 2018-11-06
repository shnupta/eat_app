import 'package:flutter/material.dart';

import 'package:eat_app/structures.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DynamicList<int> test = DynamicList<int>();

    test.add(1);
    test.add(2);
    test.add(3);

    int a = test.pop();

    print(a);
    return Container();
  }
}
