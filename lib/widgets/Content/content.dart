import 'package:flutter/material.dart';
import 'package:pr0gramm/content/file_loader.dart';

class Content extends StatelessWidget {
  downloadThumbnail(){
    FileLoader.getThumbnail(mediaLink);
  }

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}