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
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(8),
      color: Colors.grey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("User: " + name),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Column(
                  children: <Widget>[Text(content)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
