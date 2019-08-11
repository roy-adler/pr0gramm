import 'package:flutter/cupertino.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';

class Pr0grammContentContainer extends StatelessWidget {
  bool atEnd;
  bool atStart;
  String error;
  List<dynamic> items;

  Pr0grammContentContainer({this.atEnd, this.atStart, this.error, this.items});

  factory Pr0grammContentContainer.fromJson(Map<String, dynamic> parsedJson) {
    return Pr0grammContentContainer(
      atEnd: parsedJson['atEnd'],
      atStart: parsedJson['atStart'],
      error: parsedJson['error'],
      items: parsedJson['items'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
