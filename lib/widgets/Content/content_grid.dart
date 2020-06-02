import 'package:flutter/material.dart';
import 'package:pr0gramm/animations/enter_exit_route.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/widgets/thumb_widget.dart';
import 'package:pr0gramm/pages/item_page.dart';

class ContentGrid extends StatelessWidget {
  final List<Pr0grammContent> contentList;

  ContentGrid({this.contentList});

  void _route(BuildContext context, int initIndex) {
    PageController pageController = PageController(initialPage: initIndex);
    Widget pageViewBuilder = PageView.builder(
      controller: pageController,
      itemCount: contentList.length,
      itemBuilder: (BuildContext context, int index) {
        return ItemPage(pr0grammContent: contentList[index]);
      },
    );

    Navigator.of(context).push(ScaleRoute(page: pageViewBuilder));
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150.0,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => _route(context, index),
            child: ThumbWidget(pr0grammContent: contentList[index]),
          );
        },
        childCount: contentList.length,
      ),
    );
  }
}
