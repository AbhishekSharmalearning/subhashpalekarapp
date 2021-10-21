import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

class VideoStreamingPage extends StatelessWidget {
  final String youtubeId;
  const VideoStreamingPage({
    Key? key,
    @PathParam() required this.youtubeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'HELLO AB HO JAAA BHAI',
      ),
    );
  }
}

