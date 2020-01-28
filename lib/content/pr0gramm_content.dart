import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pr0gramm/content/file_loader.dart';
import 'package:pr0gramm/design/pr0gramm_colors.dart';
import 'package:pr0gramm/pages/video_screen.dart';
import 'package:pr0gramm/widgets/Pr0Text.dart';
import 'package:pr0gramm/widgets/loadingIndicator.dart';

class Pr0grammContent extends StatelessWidget {
  final int id;
  final int promoted;
  final int userId;
  final int up;
  final int down;
  final int created;
  final String mediaLink;
  final String thumb;
  final String fullSize;
  final double width;
  final double height;
  final bool audio;
  final String source;
  final int flags;
  final int deleted;
  final String user;
  final int mark;
  final int gift;
  final MediaType mediaType;

  Pr0grammContent({
    this.id,
    this.promoted,
    this.userId,
    this.up,
    this.down,
    this.created,
    this.mediaLink,
    this.thumb,
    this.fullSize,
    this.width,
    this.height,
    this.audio,
    this.source,
    this.flags,
    this.deleted,
    this.user,
    this.mark,
    this.gift,
    this.mediaType,
  });

  factory Pr0grammContent.dummy() {
    return new Pr0grammContent(
      id: 0,
      promoted: 0,
      up: 2,
      userId: 63701,
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
      userId: json["userId"],
      up: json["up"],
      down: json["down"],
      created: json["created"],
      mediaLink: json["image"],
      thumb: json["thumb"],
      fullSize: json["fullsize"],
      width: json["width"].toDouble(),
      height: json["height"].toDouble(),
      audio: json["audio"],
      source: json["source"],
      flags: json["flags"],
      deleted: json["deleted"],
      user: json["user"],
      mark: json["mark"],
      gift: json["gift"],
      mediaType: getMediaTypeFromImage(json["image"]),
    );
  }


  // TODO: ToString prints not all the variables
  String asString() {
    String heading = "Pr0grammContent:\n";
    String body = " id: $id\n promoted: $promoted\n userId: $userId\n up: $up\n"
        " down: $down\n created: $created\n image: $mediaLink\n thumb: $thumb\n"
        " fullsize: $fullSize\n width: $width\n height: $height\n"
        " audio: $audio\n";
    return heading + body;
  }

  Widget thumbnail() {
    return Hero(
      tag: id,
      child: Container(
        width: 200,
        height: 200,
        child: FittedBox(
          fit: BoxFit.cover,
          child: _getContent(fullScreen: false),
        ),
      ),
    );
  }

  Widget bigPicture() {
    return AspectRatio(
      aspectRatio: width / height,
      child: _getContent(fullScreen: true),
    );
  }

  Future<Widget> fileToWidgetLoader(bool fullScreen) async {
    try {
      Future<File> loadingFile = fullScreen
          ? FileLoader.getMedia(mediaLink)
          : FileLoader.getThumbnail(thumb);
      File mediaFile = await loadingFile;
      if (mediaType == MediaType.vid && fullScreen) {
        // TODO: Videoplayer needs to use downloaded files (Also use streaming while File isn't there)
        return VideoWidget(pr0grammContent: this);
      }
      return Image.file(mediaFile);
    } catch (error) {
      print("FileLoaderError:${error.toString()}");
    }

    return Container(
      width: width,
      height: height,
      color: richtigesGrau,
      child: Center(
        child: Text(
          "Ladefehler",
          style: TextStyle(color: iRGENDWASDOOFESISTPASSIERTFarbe),
        ),
      ),
    );
  }

  Widget _getContent({bool fullScreen = false}) {
    return FutureBuilder(
      future: fileToWidgetLoader(fullScreen),
      builder: (context, snapshot) {
        return Stack(
          children: <Widget>[
            AnimatedOpacity(
              opacity: snapshot.hasData ? 1 : 0,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              child: snapshot.hasData ? snapshot.data : Container(),
            ),
            snapshot.hasData ? Container() : LoadingIndicator(),
          ],
        );
      },
    );
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

  Widget buildVotes() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                child: Pr0Text(
                  (up - down).toString(),
                  fontSize: 32,
                ),
              ),
              Icon(CupertinoIcons.heart_solid, color: standardSchriftfarbe),
            ],
          ),
          Container(
            child: Pr0Text(
              user,
              fontSize: 22,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => thumbnail();
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
