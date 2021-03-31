import 'dart:io';

import 'file_loader.dart';

class Pr0grammContent {
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

  copy({
    id,
    promoted,
    userId,
    up,
    down,
    created,
    mediaLink,
    thumb,
    fullSize,
    width,
    height,
    audio,
    source,
    flags,
    deleted,
    user,
    mark,
    gift,
    mediaType,
  }) {
    return Pr0grammContent(
      id: this.id,
      promoted: this.promoted,
      userId: this.userId,
      up: this.up,
      down: this.down,
      created: this.created,
      mediaLink: this.mediaLink,
      thumb: this.thumb,
      fullSize: this.fullSize,
      width: this.width,
      height: this.height,
      audio: this.audio,
      source: this.source,
      flags: this.flags,
      deleted: this.deleted,
      user: this.user,
      mark: this.mark,
      gift: this.gift,
      mediaType: this.mediaType,
    );
  }

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
  @override
  String toString() {
    String heading = "Pr0grammContent:\n";
    String body = " id: $id\n promoted: $promoted\n userId: $userId\n up: $up\n"
        " down: $down\n created: $created\n image: $mediaLink\n thumb: $thumb\n"
        " fullsize: $fullSize\n width: $width\n height: $height\n"
        " audio: $audio\n";
    return heading + body;
  }

  Future<File> getThumbnail() async {
    try {
      return FileLoader.getThumbnail(thumb);
    } catch (error) {
      print("FileLoaderError:${error.toString()}");
    }
    return null;
  }

  Future<File> getMedia() async {
    try {
      return FileLoader.getMedia(mediaLink);
    } catch (error) {
      print("FileLoaderError:${error.toString()}");
    }
    return null;
  }
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
