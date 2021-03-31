import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FileLoader {
  static Future<File> getThumbnail(String mediaLink) async {
    return await thumbnailExists(mediaLink) ??
        _downloadFile(
          _buildThumbURL(mediaLink),
          _addFolder(mediaLink, "thumb"),
        );
  }

  static Future<File> getMedia(String mediaLink) async {
    return await mediaExists(mediaLink) ??
        _downloadFile(
          _buildMediaURL(mediaLink),
          _addFolder(mediaLink, "original"),
        );
  }

  static Future<File> thumbnailExists(String mediaLink) async {
    File file = await _getPreparedFile(_addFolder(mediaLink, "thumb"));
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  static Future<File> mediaExists(String mediaLink) async {
    File file = await _getPreparedFile(_addFolder(mediaLink, "original"));
    if (await file.exists()) {
      return file;
    }
    return null;
  }

  static Future<File> _getPreparedFile(String filePath) async {
    String filename = path.dirname(filePath);
    String dir = (await getApplicationDocumentsDirectory()).path;
    String fileDir = '$dir/$filename/';
    return File(fileDir + path.basename(filePath));
  }

  static String _addFolder(String mediaLink, String folderName) {
    return "${path.dirname(mediaLink)}/$folderName/${path.basename(mediaLink)}";
  }

  static Future<File> _downloadFile(String url, String filePath) async {
    String filename = path.dirname(filePath);
    String dir = (await getApplicationDocumentsDirectory()).path;
    String fileDir = '$dir/$filename/';
    File file = new File(fileDir + path.basename(filePath));

    // Download file if it doesn't exists
    try {
      if (!(await Directory(fileDir).exists())) {
        new Directory(fileDir)
            .create(recursive: true)
            .then((Directory directory) {
          print("created dir: ${directory.path}");
        });
      }

      http.Client _client = new http.Client();

      var req = await _client.get(Uri.parse(url));
      var bytes = req.bodyBytes;
      await file.writeAsBytes(bytes);
    } catch (error) {
      print("DownloadError: " + error.toString());
    }

    return file;
  }

  static String _buildMediaURL(String mediaLink) {
    String media = "";

    switch (_getMediaTypeFromUrl(mediaLink)) {
      case MediaType.pic:
        media = "img";
        break;
      case MediaType.vid:
        media = "vid";
        break;
    }

    return "https://$media.pr0gramm.com/$mediaLink";
  }

  static String _buildThumbURL(String mediaLink) {
    String media = "thumb";
    return "https://$media.pr0gramm.com/$mediaLink";
  }

  static MediaType _getMediaTypeFromUrl(String url) {
    if (url.endsWith("mp4")) {
      return MediaType.vid;
    }
    return MediaType.pic;
  }
}

enum MediaType {
  pic,
  vid,
}
