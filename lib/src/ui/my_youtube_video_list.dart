import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:provider/provider.dart';
import 'package:subhashpalekarapp/utils/Downloader.dart';
import 'package:subhashpalekarapp/utils/connectionStatusSingleton.dart';
import 'dart:async';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import '../ui/custom_video_tile.dart';


class MyYoutubeVideoList extends StatefulWidget {

  final String choiceValue;
  const MyYoutubeVideoList({Key? key,required this.choiceValue}) : super(key: key);

  @override
  _MyYoutubeVideoListState createState() => _MyYoutubeVideoListState();
}

class _MyYoutubeVideoListState extends State<MyYoutubeVideoList> {

  var _connectionStatus = 'Unknown';
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;

  List videoList = [
    {
      'title' : 'ZERO BUDGET NATURAL FARMING (ZBNF) | Subhash Palekar',
      'url' :'https://www.youtube.com/watch?v=m3d7X6UluNk&t=224s',
      'language':'English'
    },
    {
      'title' : 'ZBNF kannada videos (DAY 3 PART1 VIDEO 3)',
      'url' :'https://www.youtube.com/watch?v=b22Z_mbqrX8',
      'language':'Telugu'
    },
    {
      'title' : 'Waste Decomposer नहीं है स्वदेशी | Subhash Palekar | Zero Budget Natural Farming in India',
      'url' :'https://www.youtube.com/watch?v=S5UQ_bs6JXE',
      'language':'Hindi'
    },
    {
      'title' : 'ఎకరానికి రూ.10 లక్షల ఆదాయ పద్ధతి | Subhash Palekar Lessons #46 | hmtv Agri',
      'url' :'https://www.youtube.com/watch?v=R3Dy2ixBeBU',
      'language':'English'

    },
    {
      'title' : 'जीवामृत का निर्माण सीखे सुभाष पालेकर द्वारा | Make Jivamrit at Home with Subhash Palekar SPNF,ZBNF',
      'url' :'https://www.youtube.com/watch?v=Jefa3i4ZpVg',
      'language':'Hindi'
    }
  ];

  List filterList =[];

  @override
  void initState() {
    super.initState();
    connectivity = new Connectivity();
    subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result){
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      filterList.clear();
      if(widget.choiceValue.isNotEmpty && widget.choiceValue != 'All') {
        filterList.addAll(
            videoList.where((e) => e['language'] == widget.choiceValue)
                .toList());
      }else{
        filterList.addAll(videoList);
      }
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: filterList.length,
                    itemBuilder: (context,index) => customVideoTile(
                      onPressed: (){
                        Downloader().downloadVideo(
                            filterList[index]['url'],
                            filterList[index]['title']
                        );
                      },
                      title: filterList[index]['title'],
                      url: filterList[index]['url'],
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
