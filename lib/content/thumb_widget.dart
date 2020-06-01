import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/pages/video_screen.dart';
import 'package:pr0gramm/widgets/Design/loadingIndicator.dart';

class ThumbWidget extends StatelessWidget {
  final Pr0grammContent pr0grammContent;

  ThumbWidget({this.pr0grammContent});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: pr0grammContent.getThumbnail(),
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Image.file(snapshot.data)
            : LoadingIndicator();
      },
    );
  }
}
