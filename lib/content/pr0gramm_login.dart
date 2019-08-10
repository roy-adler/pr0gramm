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
    this.success,
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
      ts: parsedJson["promoted"],
      cache: parsedJson["cache"],
      rt: parsedJson["rt"],
      qc: parsedJson["qc"],
    );
  }

  String asString() {
    String heading = "Pr0grammLogin:\n";
    String body =
        " id: ${identifier}\n promoted: ${ts}\n up: ${rt}\n down: ${qc}\n"
        " created: ${success}\n image: ${cache}\n thumb: ${ban}\n";
    return heading + body;
  }

  @override
  Widget build(BuildContext context) {}
}
