import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';
import 'package:video_player/video_player.dart';

class Pr0grammLogin extends StatelessWidget {
  bool success;
  String ban;
  String identifier;
  int ts;
  String cache;
  int rt;
  int qc;

  Pr0grammLogin({
    this.success = false,
    this.ban,
    this.identifier,
    this.ts,
    this.cache,
    this.rt,
    this.qc,
  });

  factory Pr0grammLogin.fromJson(Map<String, dynamic> parsedJson) {
    return new Pr0grammLogin(
      success: parsedJson['success'],
      ban: parsedJson['ban'],
      identifier: parsedJson["identifier"],
      ts: parsedJson["ts"],
      cache: parsedJson["cache"],
      rt: parsedJson["rt"],
      qc: parsedJson["qc"],
    );
  }

  String asString() {
    String heading = "Pr0grammLogin:\n";
    String body =
        " success: ${success}\n ban: ${ban}\n identifier: ${identifier}\n"
        " ts: ${ts}\n cache: ${cache}\n rt: ${rt}\n qc: ${qc}\n";
    return heading + body;
  }

  greyText(String s) {
    return Text(s, style: TextStyle(color: standardSchriftfarbe));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        greyText("Pr0gramm Login Data"),
        greyText(
          " success: ${success}\n ban: ${ban}\n identifier: ${identifier}\n"
          " ts: ${ts}\n cache: ${cache}\n rt: ${rt}\n qc: ${qc}\n",
        )
      ],
    );
  }
}
