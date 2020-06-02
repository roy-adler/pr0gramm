import 'dart:async';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/api/preferences.dart';
import 'package:pr0gramm/content/pr0gramm_content.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/package_addons/video_controls.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final File videoFile;
  final Pr0grammContent pr0grammContent;

  VideoWidget({@required this.videoFile, this.pr0grammContent});

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController _controller;

  var chewieController;

  Completer loaded =
      Completer(); // TODO: Completer for video input (UPDATE NOT NEEDED: Is it needed?)

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    chewieController = ChewieController(
      videoPlayerController: _controller,
      aspectRatio: widget.pr0grammContent.width / widget.pr0grammContent.height,
      autoPlay: false,
      looping: true,
      customControls: VideoControls(
        iconColor: pr0grammOrange,
        backgroundColor: richtigesGrau.withOpacity(0.3),
      ),
    );
    () async {
      if (await Preferences.muted()) {
        _controller.setVolume(0);
      }
    }();
    loaded.complete();
    _controller.play();
  }

  @override
  void dispose() {
    // TODO: Repair this janky disposing!
    _controller.dispose();
    chewieController.dispose();
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chewie(
      controller: chewieController,
    );
  }
}
