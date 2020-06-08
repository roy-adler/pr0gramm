import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/pages/video_screen.dart';
import 'package:pr0gramm/widgets/Design/loadingIndicator.dart';
import 'package:preload_page_view/preload_page_view.dart';

import 'package:video_player/video_player.dart';

class MediaWidget extends StatelessWidget {
  final Pr0grammContent pr0grammContent;
  final PreloadPageController preloadPageController;
  final int itemPageIndex;

  MediaWidget({
    this.pr0grammContent,
    this.preloadPageController,
    this.itemPageIndex,
    Key key,
  }) : super(key: key);

  Widget fileToWidget(File mediaFile) {
    if (pr0grammContent.mediaType == MediaType.vid) {
      VideoPlayerController _controller = VideoPlayerController.file(mediaFile);
      preloadPageController.addListener(() {
        double currentIndex = preloadPageController.page;
        double lambda = 0.5;
        double dif = (itemPageIndex - currentIndex).abs();
        if (dif < lambda) {
          _controller.play();
        } else {
          _controller.pause();
        }
      });
      return VideoWidget(
        videoFile: mediaFile,
        pr0grammContent: pr0grammContent,
        videoPlayerController: _controller,
      );
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
