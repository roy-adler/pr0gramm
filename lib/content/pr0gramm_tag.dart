import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';

class Pr0grammTag extends StatelessWidget {
  final int id;
  final double confidence;
  final String tag;
  final double padd = 6;
  final double roundness = 6;
  final double marg = 4;

  Pr0grammTag({this.id, this.confidence, this.tag});

  factory Pr0grammTag.fromJson(Map<String, dynamic> parsedJson) {
    return Pr0grammTag(
      id: parsedJson['id'],
      confidence: parsedJson['confidence'],
      tag: parsedJson['tag'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(marg),
      decoration: BoxDecoration(
        color: tagHintergrund,
        borderRadius: BorderRadius.circular(roundness),
      ),
      padding: EdgeInsets.all(padd),
      child: Text(
        tag,
        style: TextStyle(color: standardSchriftfarbe),
        maxLines: 1,
      ),
    );
  }
}
