import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm_app/pages/video_screen.dart';
import 'package:video_player/video_player.dart';

class Pr0grammContent extends StatelessWidget {
  final int id;
  final int promoted;
  final int up;
  final int down;
  final int created;
  final String image;
  final String thumb;
  final String fullsize; //TODO
  final double width;
  final double height;
  final bool audio;

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

  factory Pr0grammContent.dummy() {
    return new Pr0grammContent(
      id: 0,
      promoted: 0,
      up: 2,
      down: 3,
      created: 0,
      image: "",
      thumb: "",
      fullsize: "",
      width: 200,
      height: 400,
      audio: false,
    );
  }

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
    String body = " id: $id\n promoted: $promoted\n up: $up\n down: $down\n"
        " created: $created\n image: $image\n thumb: $thumb\n"
        " fullsize: $fullsize\n width: $width\n height: $height\n"
        " audio: $audio\n";
    return heading + body;
  }

  Widget smallPicture() {
    return Hero(
      tag: id,
      child: Container(
        width: 200,
        height: 200,
        child: FittedBox(
          fit: BoxFit.cover,
          child: _getPr0Image(),
        ),
      ),
    );
  }

  Widget bigPicture() {
    return Hero(
      tag: id,
      child: Container(
        width: width, //TODO
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: _getPr0Image(bigPicture: true),
        ),
      ),
    );
  }

  Widget fullScreenPicture() {
    return Hero(
      tag: id,
      child: Container(
        width: 200,
        height: 200,
        child: FittedBox(
          fit: BoxFit.cover,
          child: _getPr0Image(),
        ),
      ),
    );
  }

  Widget _getPr0Image({bool bigPicture = false}) {
    Widget pr0Image = Image.network(
        "https://media.giphy.com/media/xUOxfjsW9fWPqEWouI/giphy.gif");
    if (image.endsWith("jpg") || image.endsWith("png")) {
      pr0Image = Image.network("https://img.pr0gramm.com/" + image);
    } else if (image.endsWith("mp4")) {
      if (bigPicture) pr0Image = VideoScreen();
    }

    return pr0Image;
  }

  @override
  Widget build(BuildContext context) => smallPicture();
}
