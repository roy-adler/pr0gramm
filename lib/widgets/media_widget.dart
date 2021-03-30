import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/widgets/Design/loadingIndicator.dart';
import 'package:preload_page_view/preload_page_view.dart';


class MediaWidget extends StatelessWidget {
  final Pr0grammContent pr0grammContent;
  final int itemPageIndex;

  MediaWidget({
    this.pr0grammContent,
    this.itemPageIndex,
    Key key, PreloadPageController preloadPageController,
  }) : super(key: key);

  Widget fileToWidget(File mediaFile) {
    if (pr0grammContent.mediaType == MediaType.vid) {

    }
    return Image.file(mediaFile);
  }


  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: pr0grammContent.width / pr0grammContent.height,
      child: FutureBuilder(
        future: pr0grammContent.getMedia(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Hero(
                  tag: pr0grammContent.id,
                  child: fileToWidget(snapshot.data),
                )
              : LoadingIndicator();
        },
      ),
    );
  }
}
