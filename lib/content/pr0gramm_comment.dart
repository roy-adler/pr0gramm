import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:pr0gramm_app/content/pr0gramm_content.dart';
import 'package:pr0gramm_app/pages/item_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';
import 'package:intl/intl.dart';

class Pr0grammComment extends StatelessWidget {
  final int id;
  final int parent;
  final String content;
  final DateTime created;
  final int up;
  final int down;
  final double confidence;
  final String name;
  final int mark;
  static const double commentPadding = 20;
  static const double heightPadding = 6;

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
      created:
          DateTime.fromMillisecondsSinceEpoch(1000 * parsedJson['created']),
      up: parsedJson['up'],
      down: parsedJson['down'],
      confidence: parsedJson['confidence'].toDouble(),
      name: parsedJson['name'],
      mark: parsedJson['mark'],
    );
  }

  _rowText(String s) {
    return Flexible(
      child: Text(
        s,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: standardSchriftfarbeAusgegraut,
          fontSize: 12,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: Linkify(
              onOpen: (url) async {
                if (await canLaunch(url)) {
                  if (url.contains("pr0gramm")) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => ItemPage(
                          pr0grammContent: Pr0grammContent.dummy(),
                        ),
                      ),
                    );
                  } else {
                    await launch(url);
                  }
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
          ),
          Container(height: heightPadding,),
          Flexible(
            child: Row(
              children: <Widget>[
                _rowText(name),
                Container(
                  width: commentPadding,
                ),
                _rowText((up - down).toString() + ' Punkte'),
                Container(
                  width: commentPadding,
                ),
                _rowText(_showTime(created)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _showTime(DateTime dateTime) {
    String time = dateTime.hour.toString();
    String formattedDate = DateFormat('kk:mm').format(dateTime);
    print(formattedDate);
    return formattedDate;
  }
}
