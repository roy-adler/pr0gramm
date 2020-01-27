import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/pages/video_screen.dart';
import 'package:pr0gramm/widgets/Pr0Text.dart';

class Pr0grammContent extends StatelessWidget {
  final int id;
  final int promoted;
  final int up;
  final int down;
  final int created;
  final String mediaLink;
  final String thumb;
  final String fullSize; //TODO
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
    this.mediaLink,
    this.thumb,
    this.fullSize,
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
      mediaLink: "",
      thumb: "",
      fullSize: "",
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
      mediaLink: json["image"],
      thumb: json["thumb"],
      fullSize: json["fullsize"],
      width: json["width"].toDouble(),
      height: json["height"].toDouble(),
      audio: json['audio'],
      mediaType: getMediaTypeFromImage(json["image"]),
    );
  }

  String asString() {
    String heading = "Pr0grammContent:\n";
    String body = " id: $id\n promoted: $promoted\n up: $up\n down: $down\n"
        " created: $created\n image: $mediaLink\n thumb: $thumb\n"
        " fullsize: $fullSize\n width: $width\n height: $height\n"
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
          child: _getContent(),
        ),
      ),
    );
  }

  Widget bigPicture() {
    return _getContent(fullScreen: true);
  }

  Widget fullScreenPicture() {
    return Hero(
      tag: id,
      child: Container(
        width: 200,
        height: 200,
        child: FittedBox(
          fit: BoxFit.cover,
          child: _getContent(),
        ),
      ),
    );
  }

  Widget _getContent({bool fullScreen = false}) {
    if (mediaType == MediaType.vid && fullScreen) {
      return VideoWidget(pr0grammContent: this);
    }
    return Image.network(buildURL(fullScreen));
  }

  String get thumbURL {
    String media = "";
    switch (mediaType) {
      case MediaType.pic:
        media = "img";
        break;
      case MediaType.vid:
        media = "vid";
        break;
    }
    return "https://$media.pr0gramm.com/$thumb";
  }

  String get mediaURL {
    String media = "";
    switch (mediaType) {
      case MediaType.pic:
        media = "img";
        break;
      case MediaType.vid:
        media = "vid";
        break;
    }
    return "https://$media.pr0gramm.com/$mediaLink";
  }

  String buildURL(bool fullScreen) {
    String media = "";
    String type = "";
    if (fullScreen) {
      type = mediaLink;
      switch (mediaType) {
        case MediaType.pic:
          media = "img";
          break;
        case MediaType.vid:
          media = "vid";
          break;
      }
    } else {
      type = thumb;
      media = "thumb";
    }
    return "https://$media.pr0gramm.com/$type";
  }

  Widget _buildVotes() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(CupertinoIcons.add_circled, color: standardSchriftfarbe),
                  Container(
                    width: 4,
                  ),
                  Icon(CupertinoIcons.minus_circled,
                      color: standardSchriftfarbe),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Pr0Text((up - down).toString()),
              ),
              Icon(CupertinoIcons.heart_solid, color: standardSchriftfarbe),
            ],
          ),
          Container(
            child: Pr0Text("OCname"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => smallPicture();
}

MediaType getMediaTypeFromImage(String image) {
  if (image.endsWith("mp4")) {
    return MediaType.vid;
  }
  return MediaType.pic;
}

enum MediaType {
  pic,
  vid,
}
