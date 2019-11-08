import 'package:flutter/material.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';

class Pr0Text extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const Pr0Text(this.text, {this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(color: standardSchriftfarbe),
    );
  }
}
