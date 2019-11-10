import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pr0gramm_app/api/response_parser.dart';
import 'package:pr0gramm_app/content/captchaContainer.dart';

class Pr0Captcha extends StatelessWidget {
  String token;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      clipBehavior: Clip.antiAlias,
      child: FutureBuilder(
        key: Key("hey"),
        future: ResponseParser.getCaptcha(),
        builder: (context, snapshot) {
          Image image;
          if (snapshot.hasData) {
            CaptchaContainer captchaContainer = snapshot.data;
            print(captchaContainer.asString());
            int position = captchaContainer.captcha.indexOf(',') + 1;
            if (captchaContainer.captcha.length > position) {
              Uint8List decoded =
                  base64Decode(captchaContainer.captcha.substring(position));
              token = captchaContainer.token;
              image = Image.memory(decoded);
            }
          }
          return Stack(
            children: <Widget>[
              AnimatedOpacity(
                curve: Curves.easeOut,
                duration: Duration(milliseconds: 400),
                opacity: snapshot.hasData ? 1 : 0,
                child: image ?? Container(width: 360, height: 90),
              ),
            ],
          );
        },
      ),
    );
  }
}
