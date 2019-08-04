import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    Image image = Image.network("https://img.pr0gramm.com/" + thumb);

    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
      child: Stack(
        children: <Widget>[image],
      ),
    );
  }
}
