import 'package:flutter/material.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';

class Pr0Text extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final bool heading;

  const Pr0Text(this.text,
      {this.textAlign = TextAlign.center, this.heading = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: standardSchriftfarbe,
        fontSize: heading ? 22 : 16,
      ),
    );
  }
}
