import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm_app/design/pr0gramm_colors.dart';
import 'package:video_player/video_player.dart';

class Pr0grammContent extends StatelessWidget {
  int id;
  int promoted;
  int up;
  int down;
  int created;
  String image;
  String thumb;
  String fullsize; //TODO
  double width;
  double height;
  bool audio;

  Pr0grammContent({
    this.id,
    this.promoted,
    this.up,
    this.down,
    this.created,
    this.image,
    this.thumb,
    this.fullsize,
    this.width,
    this.height,
    this.audio,
  });

  factory Pr0grammContent.fromJson(Map<String, dynamic> json) {
    return new Pr0grammContent(
      id: json["id"],
      promoted: json["promoted"],
      up: json["up"],
      down: json["down"],
      created: json["created"],
      image: json["image"],
      thumb: json["thumb"],
      fullsize: json["fullsize"],
      width: json["width"].toDouble(),
      height: json["height"].toDouble(),
      audio: json['audio'],
    );
  }

  String asString() {
    String heading = "Pr0grammContent:\n";
    String body =
        " id: ${id}\n promoted: ${promoted}\n up: ${up}\n down: ${down}\n"
        " created: ${created}\n image: ${image}\n thumb: ${thumb}\n"
        " fullsize: ${fullsize}\n width: ${width}\n height: ${height}\n"
        " audio: ${audio}\n";
    return heading + body;
  }

  @override
  Widget build(BuildContext context) {
    Image pr0Image = Image.network(
        "https://media.giphy.com/media/xUOxfjsW9fWPqEWouI/giphy.gif");
    if (image.endsWith("jpg") || image.endsWith("png")) {
      pr0Image = Image.network("https://img.pr0gramm.com/" + image);
    } else if(image.endsWith("mp5")) {
      return Center(
        child: Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                child: (playerController != null
                    ? VideoPlayer(
                        playerController,
                      )
                    : Container()),
              ),
            ),
            CupertinoButton(
              onPressed: () {
                createVideo("https://img.pr0gramm.com/" + image);
                playerController.play();
              },
              child: Icon(Icons.play_arrow),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          child: FittedBox(
            fit: BoxFit.cover,
            child: pr0Image,
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Text(
            image.substring(image.length - 3),
            style: TextStyle(
              color: pr0grammOrange,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  VideoPlayerController playerController;
  VoidCallback listener;

  void createVideo(String quelle) {
    if (playerController == null) {
      playerController = VideoPlayerController.network(
          quelle)
        ..addListener(listener)
        ..setVolume(1.0)
        ..initialize()
        ..play();
    } else {
      if (playerController.value.isPlaying) {
        playerController.pause();
      } else {
        playerController.initialize();
        playerController.play();
      }
    }
  }
}
