import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/widgets/Content/content_grid.dart';

class ContentPageView extends StatelessWidget {
  final List<Pr0grammContent> contentList;
  final ScrollController controller;
  final SliverAppBar appBar;

  const ContentPageView(
      {Key key, this.contentList, this.controller, this.appBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: <Widget>[
        appBar,
        ContentGrid(contentList: contentList),
      ],
    );
  }
}
