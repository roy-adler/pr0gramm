import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/pages/item_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';

class Pr0Comment extends StatelessWidget {
  final int id;
  final int parent;
  final String content;
  final DateTime created;
  final int up;
  final int down;
  final double confidence;
  final String name;
  final int mark;
  final List<String> names;
  static const double commentPadding = 20;
  static const double heightPadding = 6;

  Pr0Comment({
    this.id,
    this.parent,
    this.content,
    this.created,
    this.up,
    this.down,
    this.confidence,
    this.name,
    this.mark,
    this.names,
  });

  factory Pr0Comment.fromJson(
    Map<String, dynamic> parsedJson, {
    List<String> names,
  }) {
    return Pr0Comment(
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
      names: names ?? [],
    );
  }


  _rowText(String s, {Color color = standardSchriftfarbeAusgegraut}) {
    return Flexible(
      child: Text(
        s,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: color,
          fontSize: 12,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  int points() {
    return up - down;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "id: $id, parent: $parent";
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
                        // TODO: Do the linking right! (maybe use .com)
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
          Container(
            height: heightPadding,
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                // TODO: Use Badge
                _rowText(name,
                    color: names.contains(name)
                        ? pr0grammOrange
                        : standardSchriftfarbe),
                Container(
                  width: commentPadding,
                ),
                _rowText(points().toString() + ' Punkte'),
                Container(
                  width: commentPadding,
                ),
                _rowText(_showTime(created),
                    color: standardSchriftfarbe.withOpacity(0.7)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _showTime(DateTime dateTime) {
    Duration differ = DateTime.now().difference(created);
    int years = (differ.inDays / 365).floor();
    if (years > 0) {
      if (years == 1) {
        return "Vor 1 Jahr";
      }
      return "Vor $years Jahren";
    }

    int days = differ.inDays.floor();
    if (days > 0) {
      if (days == 1) {
        return "Vor 1 Tag";
      }
      return "Vor $days Tagen";
    }

    int hours = differ.inHours.floor();
    if (hours > 0) {
      if (hours == 1) {
        return "Vor 1 Stunde";
      }
      return "Vor $hours Stunden";
    }

    int minutes = differ.inMinutes.floor();
    if (minutes > 0) {
      if (minutes == 1) {
        return "Vor 1 Minute";
      }
      return "Vor $minutes Minuten";
    }

    int seconds = differ.inSeconds.floor();
    if (seconds == 1) {
      return "Vor 1 Sekunde";
    }
    return "Vor $seconds Sekunden";
  }
}
