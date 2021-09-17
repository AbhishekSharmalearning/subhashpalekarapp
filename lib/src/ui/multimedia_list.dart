import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:subhashpalekarapp/utils/Constants.dart';

import 'my_audio_list.dart';
import 'my_youtube_video_list.dart';

class MultimediaList extends StatelessWidget {
  const MultimediaList({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    AudioPlayer audioPlayer = AudioPlayer();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text('Subhash Palekar App'),
          centerTitle: true,
          actions: [
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return Constants.choices.map((String choice) {
                  return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice)
                  );
                }).toList();
                },
            )
          ],
          bottom: const TabBar(
            indicatorColor: Colors.green,
              indicatorWeight: 5.0,
              tabs: [
                Tab(
                  icon: Icon(Icons.video_camera_front),
                  text: ('Video'),
                ),
                Tab(
                  icon: Icon(
                      Icons.audiotrack
                  ),
                  text: (
                      'Audio'
                  ),
                )
              ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: MyYoutubeVideoList()),
            Center(child: MyAudioList()),
          ],
        ),
      ),
    );
  }

  choiceAction(String choice) {

  }
}
