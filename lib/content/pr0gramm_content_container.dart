import 'package:flutter/cupertino.dart';

class Pr0ContentContainer extends StatelessWidget {
  final bool atEnd;
  final bool atStart;
  final String error;
  final List<dynamic> items;

  Pr0ContentContainer({this.atEnd, this.atStart, this.error, this.items});

  factory Pr0ContentContainer.fromJson(Map<String, dynamic> parsedJson) {
    return Pr0ContentContainer(
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
