import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoStreamingPage extends StatelessWidget {
  final String youtubeId;
  const VideoStreamingPage({
    Key? key,
    @PathParam() required this.youtubeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: youtubeId, //Add videoID.
          flags: YoutubePlayerFlags(
            hideControls: false,
            controlsVisibleAtStart: true,
            autoPlay: false,
            mute: false,
          ),
        ),
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blue,
      ),
    );
  }
}

