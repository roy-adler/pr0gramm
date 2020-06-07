import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/widgets/thumb_widget.dart';
import 'package:pr0gramm/pages/item_page.dart';
import 'package:preload_page_view/preload_page_view.dart';

class ContentGrid extends StatelessWidget {
  final List<Pr0grammContent> contentList;
  final double thumbPadding;
  final int filter;

  ContentGrid({
    this.contentList,
    this.thumbPadding = 8.0,
    Key key,
    this.filter,
  }) : super(key: key);

  void _route(BuildContext context, int initIndex) {
    PreloadPageController preloadPageController = PreloadPageController(
      initialPage: initIndex,
      keepPage: true,
    );
    preloadPageController.addListener(() {
      contentList[preloadPageController.page.floor()];
    });

    //var a = pageController.page ?? -2.0;

    Widget pageViewBuilder = PreloadPageView.builder(
      controller: preloadPageController,
      itemCount: contentList.length,
      preloadPagesCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return ItemPage(
          pr0grammContent: contentList[index],
          index: index,
          filter: filter,
          preloadPageController: preloadPageController,
        );
      },
    );

    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => pageViewBuilder,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150.0,
        mainAxisSpacing: thumbPadding,
        crossAxisSpacing: thumbPadding,
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
