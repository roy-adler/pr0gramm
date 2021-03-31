import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/api/response_parser.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/content/pr0gramm_tag.dart';
import 'package:pr0gramm/design/animated_wrap.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/pages/contents_page.dart';

class TagPage extends StatefulWidget {
  final Pr0grammContent pr0grammContent;
  final int filter;

  TagPage({@required this.pr0grammContent, this.filter});

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
    List<Widget> widgetList = tagList;
    widgetList.add(moreTagsButton(moreItems));
    return widgetList;
  }

  Widget buildTag(Pr0grammTag tag) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
              fullscreenDialog: true,
              builder: (context) =>
                  ContentsPage(tagSearch: tag.tag, filter: widget.filter))),
      child: Container(
        margin: EdgeInsets.all(tag.marg),
        decoration: BoxDecoration(
          color: tagHintergrund,
          borderRadius: BorderRadius.circular(tag.roundness),
        ),
        padding: EdgeInsets.all(tag.padd),
        child: Text(
          tag.tag,
          style: TextStyle(color: standardSchriftfarbe),
          maxLines: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ResponseParser.getTagsOverID(widget.pr0grammContent.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Pr0grammTag> pr0TagList = snapshot.data;
          List<Widget> tagList = pr0TagList.map((e) => buildTag(e)).toList();

          int foldedItems = min(maxFoldedItems, tagList.length);
          return LayoutBuilder(
            builder: (context, constraints) => Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: constraints.maxWidth,
                  child: folded && tagList.length > foldedItems
                      ? AnimatedWrap(
                          children: getFilteredTagList(
                              tagList.sublist(0, foldedItems),
                              tagList.length - foldedItems),
                        )
                      : AnimatedWrap(children: tagList),
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
