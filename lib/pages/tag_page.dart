import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/pr0gramm_tag.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';

class TagPage extends StatefulWidget {
  final int pr0grammContentID;

  TagPage({@required this.pr0grammContentID});

  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  bool folded;
  int maxFoldedItems = 5;

  @override
  void initState() {
    folded = true;
    super.initState();
  }

  Widget moreTagsButton(int moreItems) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: EdgeInsets.all(6),
      child: GestureDetector(
        onTap: () => setState(() => folded = !folded),
        child: Text(
          "${moreItems.toString()} weitere anzeigen",
          style: TextStyle(
            color: pr0grammOrange,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  List<Widget> getFilteredTagList(List<Widget> tagList, int moreItems) {
    //tagList.add(moreTagsButton(moreItems));
    List<Widget> widgetList = tagList.map((title) => title).toList();
    widgetList.add(moreTagsButton(moreItems));
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ResponseParser.getTagsOverID(widget.pr0grammContentID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Pr0grammTag> tagList = snapshot.data;
          int foldedItems = min(maxFoldedItems, tagList.length);
          return LayoutBuilder(
            builder: (context, constraints) => Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                AnimatedContainer(
                  width: constraints.maxWidth,
                  duration: Duration(milliseconds: 500),
                  child: folded && tagList.length > foldedItems
                      ? Wrap(
                          children: getFilteredTagList(
                              tagList.sublist(0, foldedItems),
                              tagList.length - foldedItems),
                        )
                      : Wrap(children: tagList),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
