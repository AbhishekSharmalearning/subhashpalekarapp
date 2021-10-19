import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



Widget customVideoTile({required String url,required String title,onPressed}
){
  return InkWell(
      child: Column(
        children: [
          Padding(
          padding: EdgeInsets.all(8.0),
          child: YoutubePlayer(
            controller: YoutubePlayerController(
                initialVideoId: url,
                        flags: const YoutubePlayerFlags(
                          mute: false,
                          autoPlay: false,
                          disableDragSeek: false,
                          loop: false,
                          isLive: false,
                          forceHD: false,
                          enableCaption: true,
                        ),
            ),
          ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0),
            child: Text(
              '$title',
              style: TextStyle(
                fontSize: 15.0,
                color: Colors.red[700],
              ),
            ),
          ),
          TextButton.icon(
              onPressed: onPressed,
              icon: Icon(
                Icons.download,
              ),
              label: Text(
                'Download above video',
              ))
        ],
      ),
  );
}

