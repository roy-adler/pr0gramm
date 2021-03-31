import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';

class Pr0grammLogout extends StatelessWidget {
  final bool success;
  final int ts;
  final String cache;
  final int rt;
  final int qc;

  Pr0grammLogout({
    this.success,
    this.ts,
    this.cache,
    this.rt,
    this.qc,
  });

  factory Pr0grammLogout.fromJson(Map<String, dynamic> parsedJson) {
    return new Pr0grammLogout(
      success: parsedJson['success'],
      ts: parsedJson["ts"],
      cache: parsedJson["cache"],
      rt: parsedJson["rt"],
      qc: parsedJson["qc"],
    );
  }

  String asString() {
    String heading = " Logout:\n";
    String body = " success: $success\n ts: $ts\n"
        " cache: $cache\n rt: $rt\n qc: $qc\n";
    return heading + body;
  }

  greyText(String s) {
    return Text(s, style: TextStyle(color: standardSchriftfarbe));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        greyText(asString()),
      ],
    );
  }
}
