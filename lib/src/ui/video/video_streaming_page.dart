import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class VideoStreamingPage extends StatefulWidget {
  final String youtubeId;
  const VideoStreamingPage({
    Key? key,
    @PathParam() required this.youtubeId,
  }) : super(key: key);

  @override
  State<VideoStreamingPage> createState() => _VideoStreamingPageState();
}


class _VideoStreamingPageState extends State<VideoStreamingPage> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: YoutubePlayerBuilder(
        player:  YoutubePlayer(
          controller: YoutubePlayerController(
              initialVideoId: widget.youtubeId,
              flags: YoutubePlayerFlags(
                hideControls: false,
                controlsVisibleAtStart: true,
                autoPlay: false,
                mute: false,
            ),
          ),
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
        ), builder: (context , player ) {
          return Container(
            child: player,
          );
      },
      ),
    );
  }
  

}

