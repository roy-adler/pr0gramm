import 'package:flutter/material.dart';

void main() => runApp(Pr0gramm());

class Pr0gramm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pr0gramm'),
        ),
        body: Center(child: Text('Hello Schwuchti')),
      ),
    );
  }
}
