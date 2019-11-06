import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';

class CaptchaContainer extends StatelessWidget {
  final String token;
  final String captcha;
  final int ts;
  final String cache;
  final int rt;
  final int qc;

  CaptchaContainer({
    this.token,
    this.captcha,
    this.ts,
    this.cache,
    this.rt,
    this.qc,
  });

  factory CaptchaContainer.fromJson(Map<String, dynamic> parsedJson) {
    return new CaptchaContainer(
      token: parsedJson['token'],
      captcha: parsedJson['captcha'],
      ts: parsedJson["ts"],
      cache: parsedJson["cache"],
      rt: parsedJson["rt"],
      qc: parsedJson["qc"],
    );
  }

  String asString() {
    String heading = " Captcha:\n";
    String body =
        " token: $token\n captcha: ${captcha.substring(0, 40)}...\n"
        " ts: $ts\n cache: $cache\n rt: $rt\n qc: $qc\n";
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
