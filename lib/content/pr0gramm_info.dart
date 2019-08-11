import 'package:flutter/cupertino.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';

class Pr0grammInfo extends StatelessWidget {
  List<dynamic> tags;
  List<dynamic> comments;
  int ts;
  String cache;
  int rt;
  int qc;

  Pr0grammInfo({
    this.tags,
    this.comments,
    this.ts,
    this.cache,
    this.rt,
    this.qc,
  });

  factory Pr0grammInfo.fromJson(Map<String, dynamic> parsedJson) {
    return Pr0grammInfo(
      tags: parsedJson['tags'],
      comments: parsedJson['comments'],
      ts: parsedJson['ts'],
      cache: parsedJson['cache'],
      rt: parsedJson['ts'],
      qc: parsedJson['qc'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
