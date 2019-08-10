import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';

import 'package:flutter/cupertino.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';

class Pr0grammComment extends StatelessWidget {
  int id;
  int parent;
  String content;
  int created;
  int up;
  int down;
  double confidence;
  String name;
  int mark;

  Pr0grammComment({
    this.id,
    this.parent,
    this.content,
    this.created,
    this.up,
    this.down,
    this.confidence,
    this.name,
    this.mark,
  });

  factory Pr0grammComment.fromJson(Map<String, dynamic> parsedJson) {
    return Pr0grammComment(
      id: parsedJson['id'],
      parent: parsedJson['parent'],
      content: parsedJson['content'],
      created: parsedJson['created'],
      up: parsedJson['up'],
      down: parsedJson['down'],
      confidence: parsedJson['confidence'],
      name: parsedJson['name'],
      mark: parsedJson['mark'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: Colors.grey,

    );
  }
}
