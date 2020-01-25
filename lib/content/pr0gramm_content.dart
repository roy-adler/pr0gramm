import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/pages/video_screen.dart';

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
  final MediaType mediaType;

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
    this.mediaType,
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
      mediaType: MediaType.pic,
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
      mediaType: getMediaTypeFromUrl(json["image"]),
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
    return _getPr0Image(bigPicture: true);
    return Container(
      width: width, //TODO
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: _getPr0Image(bigPicture: true),
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
    String type = "";
    if (bigPicture) {
      switch (mediaType) {
        case MediaType.pic:
          type = "img";
          break;
        case MediaType.gif:
          type = "img";
          break;
        case MediaType.vid:
          type = "vid";
          break;
      }
    } else {
      type = "thumb";
    }
    String pr0API = "https://$type.pr0gramm.com/";
    Widget pr0Image = Image.network(
        "https://media.giphy.com/media/xUOxfjsW9fWPqEWouI/giphy.gif");
    if (mediaType == MediaType.pic) {
      if (bigPicture) {
        pr0Image = Image.network(pr0API + image);
      } else {
        pr0Image = Image.network(pr0API + thumb);
      }
    } else if (mediaType == MediaType.vid) {
      if (bigPicture) {
        pr0Image = VideoScreen(url: pr0API + image);
      } else {
        pr0Image = Image.network(pr0API + thumb);
      }
    } else if (mediaType == MediaType.gif) {
      if (bigPicture) {
        pr0Image = Image.network(pr0API + image);
      } else {
        pr0Image = Stack(
          children: <Widget>[
            Image.network(pr0API + thumb),
            Center(
              child: Text(
                "GIF",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      }
    }

    return pr0Image;
  }

  @override
  Widget build(BuildContext context) => smallPicture();
}

MediaType getMediaTypeFromUrl(String url) {
  if (url.endsWith("mp4")) {
    return MediaType.vid;
  } else if (url.endsWith("gif")) {
    return MediaType.gif;
  }
  return MediaType.pic;
}

enum MediaType {
  pic,
  vid,
  gif,
}
