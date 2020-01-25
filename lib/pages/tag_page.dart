import 'package:flutter/cupertino.dart';
import 'package:pr0gramm/content/pr0gramm_tag.dart';

class TagPage extends StatelessWidget {
  final List<Pr0grammTag> tagList;

  TagPage({@required this.tagList});

  @override
  Widget build(BuildContext context) {
    return Wrap(children: tagList.sublist(0, 2));
  }
}
