import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/widgets/Content/content_grid.dart';
import 'package:pr0gramm/widgets/Design/loadingIndicator.dart';

class ContentPageView extends StatelessWidget {
  final Future content;
  final ScrollController controller;
  final Function(String s) search;

  const ContentPageView({Key key, this.content, this.controller, this.search}) : super(key: key);


  SliverAppBar _getAppBar() {
    return SliverAppBar(
      backgroundColor: richtigesGrau.withOpacity(0.5),
      pinned: false,
      snap: false,
      floating: true,
      centerTitle: true,
      // expandedHeight: 200,
      title: FlatButton(
        onPressed: search("Penis"),
        color: pr0grammOrange,
        child: Icon(Icons.search),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: content,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Pr0grammContent> contentList = snapshot.data;
          return CustomScrollView(
            controller: controller,
            slivers: <Widget>[
              _getAppBar(),
              ContentGrid(contentList: contentList),
            ],
          );
        }
        return LoadingIndicator();
      },
    );
  }
}

