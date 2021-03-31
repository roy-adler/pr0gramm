import 'package:flutter/cupertino.dart';

class Pr0grammInfo extends StatelessWidget {
  final List<dynamic> tags;
  final List<dynamic> comments;
  final int ts;
  final String cache;
  final int rt;
  final int qc;

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
