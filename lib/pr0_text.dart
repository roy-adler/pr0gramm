import 'package:flutter/material.dart';
import 'package:pr0gramm_app/pr0gramm_colors.dart';

class Pr0Text extends StatelessWidget {
  final String text;

  const Pr0Text(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: standardSchriftfarbe),
    );
  }
}
