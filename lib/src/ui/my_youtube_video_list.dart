import 'package:flutter/material.dart';
import 'package:subhashpalekarapp/utils/Downloader.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import '../ui/custom_video_tile.dart';


class MyYoutubeVideoList extends StatefulWidget {
  const MyYoutubeVideoList({Key? key}) : super(key: key);

  @override
  _MyYoutubeVideoListState createState() => _MyYoutubeVideoListState();
}

class _MyYoutubeVideoListState extends State<MyYoutubeVideoList> {

  List videoList = [
    {
      'title' : 'ZERO BUDGET NATURAL FARMING (ZBNF) | Subhash Palekar',
      'url' :'https://www.youtube.com/watch?v=m3d7X6UluNk&t=224s',
    },
    {
      'title' : 'ZBNF kannada videos (DAY 3 PART1 VIDEO 3)',
      'url' :'https://www.youtube.com/watch?v=b22Z_mbqrX8',
    },
    {
      'title' : 'Waste Decomposer नहीं है स्वदेशी | Subhash Palekar | Zero Budget Natural Farming in India',
      'url' :'https://www.youtube.com/watch?v=S5UQ_bs6JXE',
    },
    {
      'title' : 'ఎకరానికి రూ.10 లక్షల ఆదాయ పద్ధతి | Subhash Palekar Lessons #46 | hmtv Agri',
      'url' :'https://www.youtube.com/watch?v=R3Dy2ixBeBU',

    },
    {
      'title' : 'जीवामृत का निर्माण सीखे सुभाष पालेकर द्वारा | Make Jivamrit at Home with Subhash Palekar SPNF,ZBNF',
      'url' :'https://www.youtube.com/watch?v=Jefa3i4ZpVg',
      ////0Hello
      ///fdbdfbfdb
      ////jfgyjgyfjgfjf
    }

  ];

  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;


  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;

  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  // @override
  // void deactivate() {
  //   // Pauses video while navigating to next page.
  //   _controller.pause();
  //   super.deactivate();
  // }
  //
  // @override
  // void dispose() {
  //   _controller.dispose();
  //   _idController.dispose();
  //   _seekToController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: videoList.length,
                    itemBuilder: (context,index) => customVideoTile(
                      onPressed: (){
                          Downloader().downloadVideo(
                              videoList[index]['url'],
                              videoList[index]['title']
                          );
                      },
                      url: videoList[index]['url'],
                      title: videoList[index]['title'],
                    ),
                    // itemBuilder: (context,index){
                    //     return Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: YoutubePlayer(
                    //         controller: YoutubePlayerController(
                    //           initialVideoId: YoutubePlayer
                    //               .convertUrlToId(videoList[index]['url']) as String,
                    //           flags: const YoutubePlayerFlags(
                    //             mute: false,
                    //             autoPlay: false,
                    //             disableDragSeek: false,
                    //             loop: false,
                    //             isLive: false,
                    //             forceHD: false,
                    //             enableCaption: true,
                    //
                    //           ),
                    //         ),
                    //         liveUIColor: Colors.amber,
                    //       ),
                    //
                    //     );
                    // },
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
