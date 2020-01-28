import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/pr0gramm_tag.dart';

class TagPage extends StatefulWidget {
  final int pr0grammContentID;

  TagPage({@required this.pr0grammContentID});

  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  bool folded;
  int maxFoldedItems;

  @override
  void initState() {
    folded = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ResponseParser.getTagsOverID(widget.pr0grammContentID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          maxFoldedItems = min(4, snapshot.data.length);
          return LayoutBuilder(
            builder: (context, constraints) => Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                AnimatedContainer(
                  width: constraints.maxWidth,
                  duration: Duration(milliseconds: 500),
                  child: folded
                      ? Wrap(children: snapshot.data.sublist(0, maxFoldedItems))
                      : Wrap(children: snapshot.data),
                ),
                CupertinoButton(
                  child: Icon(folded
                      ? CupertinoIcons.down_arrow
                      : CupertinoIcons.up_arrow),
                  onPressed: () => setState(() => folded = !folded),
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
