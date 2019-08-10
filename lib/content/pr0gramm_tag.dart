import 'package:flutter/cupertino.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';

class Pr0grammTag extends StatelessWidget {
  int id;
  double confidence;
  String tag;

  Pr0grammTag({this.id, this.confidence, this.tag});

  factory Pr0grammTag.fromJson(Map<String, dynamic> parsedJson) {
    return Pr0grammTag(
      id: parsedJson['id'],
      confidence: parsedJson['confidence'],
      tag: parsedJson['tag'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Text("ID: " + id.toString()),
          Text("Confidence: " + confidence.toString()),
          Text("Tag: " + tag),
        ],
      ),
    );
  }
}
