import 'package:flutter/material.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';

class Pr0Text extends StatelessWidget {
  final String text;
  final double fontSize;

  Pr0Text(this.text, {this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: standardSchriftfarbe,
        fontSize: fontSize,
      ),
    );
  }
}
