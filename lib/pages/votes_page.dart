import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/widgets/Design/Pr0Text.dart';

class VotesPage extends StatefulWidget {
  final Pr0grammContent pr0grammContent;

  VotesPage({this.pr0grammContent});

  @override
  _VotesPageState createState() => _VotesPageState();
}

class _VotesPageState extends State<VotesPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(CupertinoIcons.add_circled, color: standardSchriftfarbe),
                  Container(
                    width: 4,
                  ),
                  Icon(CupertinoIcons.minus_circled,
                      color: standardSchriftfarbe),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Pr0Text(
                  (widget.pr0grammContent.up - widget.pr0grammContent.down)
                      .toString(),
                  fontSize: 32,
                ),
              ),
              Icon(CupertinoIcons.heart_solid, color: standardSchriftfarbe),
            ],
          ),
          Container(
            child: Pr0Text(
              widget.pr0grammContent.user,
              fontSize: 22,
            ),
          )
        ],
      ),
    );
  }
}
