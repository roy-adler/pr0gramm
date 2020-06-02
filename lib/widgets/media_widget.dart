import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/pages/video_screen.dart';
import 'package:pr0gramm/widgets/Design/loadingIndicator.dart';

class MediaWidget extends StatelessWidget {
  final Pr0grammContent pr0grammContent;

  MediaWidget({this.pr0grammContent});

  Widget fileToWidget(File mediaFile) {
    if (pr0grammContent.mediaType == MediaType.vid) {
      return VideoWidget(
        videoFile: mediaFile,
        pr0grammContent: pr0grammContent,
      );
    }
    return Image.file(mediaFile);
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: pr0grammContent.id,
      child: AspectRatio(
        aspectRatio: pr0grammContent.width / pr0grammContent.height,
        child: FutureBuilder(
          future: pr0grammContent.getMedia(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? fileToWidget(snapshot.data)
                : LoadingIndicator();
          },
        ),
      ),
    );
  }
}
