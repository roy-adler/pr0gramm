import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';

class Pr0grammComment extends StatelessWidget {
  final int id;
  final int parent;
  final String content;
  final int created;
  final int up;
  final int down;
  final double confidence;
  final String name;
  final int mark;

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
      confidence: parsedJson['confidence'].toDouble(),
      name: parsedJson['name'],
      mark: parsedJson['mark'],
    );
  }

  _rowText(String s) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        s,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: standardSchriftfarbeAusgegraut,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(content.substring(0, 5));
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Linkify(
            onOpen: (url) async {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            linkStyle: TextStyle(color: pr0grammOrange),
            text: content,
            style: TextStyle(
              color: standardSchriftfarbe,
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                _rowText(name),
                _rowText((up - down).toString() + ' Punkte'),
                _rowText(DateTime.utc(created).minute.toString() + ' Minuten'),
              ],
            ),
          ),
          Divider(
            color: standardSchriftfarbe,
            height: 4,
            indent: 20,
            endIndent: 0,
          ),
        ],
      ),
    );
  }
}
