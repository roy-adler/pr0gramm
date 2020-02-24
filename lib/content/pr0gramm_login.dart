import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pr0grammLogin extends StatelessWidget {
  final bool success;
  final String ban;
  final String identifier;
  final int ts;
  final String cache;
  final int rt;
  final int qc;
  final String error;

  Pr0grammLogin({
    this.success = false,
    this.ban,
    this.identifier,
    this.ts,
    this.cache,
    this.rt,
    this.qc,
    this.error,
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
      error: parsedJson["error"],
    );
  }

  String asString() {
    String heading = "Pr0grammLogin:\n";
    String body = " success: $success\n ban: $ban\n identifier: $identifier\n"
        " ts: $ts\n cache: $cache\n rt: $rt\n qc: $qc\n";
    return heading + body;
  }

  String userError() {
    if (error.toLowerCase().contains("captcha")) {
      return "Falsches Captcha";
    } else if (error.toLowerCase().contains("login")) {
      return "Falsche Login-Daten";
    }
    return "Server: " + error;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        greyText("Pr0gramm Login Data"),
        greyText(
          " success: $success\n ban: $ban\n identifier: $identifier\n"
          " ts: $ts\n cache: $cache\n rt: $rt\n qc: $qc\n",
        )
      ],
    );
  }

  LoginError loginError() {
    if (error.toLowerCase().contains("captcha")) {
      return LoginError.captcha;
    } else if (error.toLowerCase().contains("login")) {
      return LoginError.userdata;
    }
    return LoginError.other;
  }
}

enum LoginError {
  userdata,
  captcha,
  other,
}
