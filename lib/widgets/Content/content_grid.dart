import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/pages/item_page.dart';

class ContentGrid extends StatelessWidget {
  final List<Pr0grammContent> contentList;

  ContentGrid({this.contentList});

  void _route(BuildContext context, Pr0grammContent pr0grammContent) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Dismissible(
          onDismissed: (_) => Navigator.of(context).pop(),
          direction: DismissDirection.horizontal,
          key: Key(pr0grammContent.id.toString()),
          child: ItemPage(
            pr0grammContent: pr0grammContent,
          ),
        ),
      ),
    );
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
            onTap: () => _route(context, contentList[index]),
            child: contentList[index],
          );
        },
        childCount: contentList.length,
      ),
    );
  }
}
