import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'pages/login_page.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: LoginPage(),
    );
  }
}
