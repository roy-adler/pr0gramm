import 'package:flutter/material.dart';
import 'package:pr0gramm/widgets/Content/content_list.dart';
import 'package:pr0gramm/widgets/Content/content_page_view.dart';
import 'package:pr0gramm/widgets/Content/content_page_view_builder.dart';

class ContentsPage extends StatefulWidget {
  // TODO: "Good" ScrollController Implementation

  @override
  _ContentsPageState createState() => _ContentsPageState();
}

class _ContentsPageState extends State<ContentsPage> {
  String tag = "";

  search(String s){
    /*setState(() {
      tag = s;
    });*/
  }

  getSfw() {
    return ContentPageView(
      content: ContentList.getSFWContentList(search: tag),
      controller: ScrollController(),
      search: search,
    );
  }

  getNsfw() {
    Function(String s) a = search;
    return ContentPageView(
      content: ContentList.getNSFWContentList(search: tag),
      controller: ScrollController(),
      search: search,
    );
  }

  getNsfl() {
    return ContentPageView(
      content: ContentList.getNSFLContentList(search: tag),
      controller: ScrollController(),
      search: search,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: MessagesPage Implementation
    return ContentPageViewBuilder(
      newsPage: Container(
        child: Center(
          child: Text("Messages"),
        ),
      ),
      sFWPage: getSfw(),
      nSFWPage: getNsfw(),
      nSFLPage: getNsfl(),
    );
    return getSfw();
  }
}
