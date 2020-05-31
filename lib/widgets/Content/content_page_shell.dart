import 'package:flutter/material.dart';
import 'package:pr0gramm/widgets/Content/contents_page.dart';

class ContentPageShell extends StatelessWidget {
  final String tagSearch;
  const ContentPageShell({Key key, this.tagSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContentsPage(tagSearch: tagSearch, shellWidget: this,);
  }
}
