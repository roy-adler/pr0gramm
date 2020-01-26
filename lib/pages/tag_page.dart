import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_tag.dart';

class TagPage extends StatefulWidget {
  final List<Pr0grammTag> tagList;

  TagPage({@required this.tagList});

  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  bool folded;
  int maxFoldedItems;

  @override
  void initState() {
    folded = true;
    maxFoldedItems = min(4, widget.tagList.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AnimatedContainer(
          color: Colors.red,
          duration: Duration(milliseconds: 500),
          child: folded
              ? Wrap(children: widget.tagList.sublist(0, maxFoldedItems))
              : Wrap(children: widget.tagList),
        ),
        CupertinoButton(
          child: Icon(
              folded ? CupertinoIcons.down_arrow : CupertinoIcons.up_arrow),
          onPressed: () => setState(() => folded = !folded),
        )
      ],
    );
  }
}
