import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/pages/item_page.dart';

class FullscreenPage extends StatelessWidget {
  final int itemPos;
  final List<Pr0grammContent> contentList;

  FullscreenPage({this.contentList, this.itemPos});

  List<Hero> _getItemPageList(
    List<Pr0grammContent> list,
    BuildContext context, {
    Function toggleFullscreen,
  }) {
    List<Hero> itemPageList = [];
    list.forEach(
      (Pr0grammContent element) => itemPageList.add(
        Hero(
          tag: element.id,
          child: ItemPage(pr0grammContent: element),
        ),
      ),
    );
    return itemPageList;
  }

  Widget pageView() {
    return PageView.builder(
      controller: PageController(initialPage: itemPos),
      scrollDirection: Axis.horizontal,
      itemCount: contentList.length,
      itemBuilder: (context, index) {
        List<Hero> itemPageList = _getItemPageList(contentList, context);
        return itemPageList[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return pageView();
  }
}
