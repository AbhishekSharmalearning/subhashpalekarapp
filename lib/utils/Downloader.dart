import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'dart:async';

class Downloader{

  Future<void> downloadVideo(String url,String title) async {
    final result = await FlutterYoutubeDownloader.downloadVideo(
        url, "$title", 18);
    print('Download Status :' '$result');
  }

}