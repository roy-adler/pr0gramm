import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/widgets/Content/content_grid.dart';

class ContentPageView extends StatelessWidget {
  final List<Pr0grammContent> contentList;
  final ScrollController controller;
  final SliverAppBar appBar;
  final int filter;

  const ContentPageView({
    Key key,
    this.contentList,
    this.controller,
    this.appBar,
    this.filter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double thumbPadding = 8.0;
    return Padding(
      padding: const EdgeInsets.all(thumbPadding),
      child: CustomScrollView(
        controller: controller,
        slivers: <Widget>[
          appBar,
          ContentGrid(
            contentList: contentList,
            thumbPadding: thumbPadding,
            filter: filter,
          ),
        ],
      ),
    );
  }
}
