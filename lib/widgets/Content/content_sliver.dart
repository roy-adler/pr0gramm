import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/widgets/Content/content_grid.dart';

class ContentSliver extends StatelessWidget {
  final ScrollController controller;
  final List<Pr0grammContent> contentList;

  const ContentSliver({Key key, this.controller, this.contentList})
      : super(key: key);

  // TODO: Implement Serach Tag Bar
  void _search() {}

  SliverAppBar _getAppBar() {
    return SliverAppBar(
      backgroundColor: richtigesGrau.withOpacity(0.5),
      pinned: false,
      snap: false,
      floating: true,
      centerTitle: true,
      // expandedHeight: 200,
      title: FlatButton(
        onPressed: _search,
        color: pr0grammOrange,
        child: Icon(Icons.search),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: <Widget>[
        _getAppBar(),
        ContentGrid(contentList: contentList),
      ],
    );
  }
}
