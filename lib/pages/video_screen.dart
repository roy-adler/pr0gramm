import 'dart:async';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final Pr0grammContent pr0grammContent;

  VideoWidget({@required this.pr0grammContent});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController _controller;

  var chewieController;

  Completer loaded = Completer(); // TODO: Completer for video input

  @override
  void initState() {
    super.initState();
    var url = widget.pr0grammContent.mediaURL;
    if (url == null) {
      url =
          'http://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_20mb.mp4';
    }

    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: widget.pr0grammContent.width / widget.pr0grammContent.height,
      autoPlay: false,
      looping: true,
    );
    loaded.complete();
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController.dispose();
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded.isCompleted) {
      return Container(
        width: 200,
        height: 200,
        color: Colors.red,
      );
    }

    return Chewie(
      controller: chewieController,
    );
  }
}
