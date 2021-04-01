import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'Design/loadingIndicator.dart';

class UserWidget extends StatelessWidget {
  final Pr0grammContent pr0grammContent;

  UserWidget({this.pr0grammContent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
