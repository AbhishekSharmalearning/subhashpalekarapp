import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:subhashpalekarapp/src/ui/custom_list_tile.dart';

class MyAudioList extends StatefulWidget {
  const MyAudioList({Key? key}) : super(key: key);

  @override
  _MyAudioListState createState() => _MyAudioListState();
}

class _MyAudioListState extends State<MyAudioList> {

  List musicList = [
    {
      'title' : 'Tech House vibes',
      'Singer' : 'by Alejandro Magaña (A. M.)',
      'url' :'https://assets.mixkit.co/music/preview/mixkit-tech-house-vibes-130.mp3',
      'coverurl':'https://i.ytimg.com/vi/v1wqdV_IZyU/maxresdefault.jpg'
    },
    {
      'title' : 'Hazy After Hours',
      'Singer' : 'by Lily J',
      'url' :'https://assets.mixkit.co/music/preview/mixkit-hazy-after-hours-132.mp3',
      'coverurl':'https://i.ytimg.com/vi/NqvmITu9i5k/maxresdefault.jpg'
    },
    {
      'title' : 'A Very Happy Christmas',
      'Singer' : 'by Michael Ramir C.',
      'url' :'https://assets.mixkit.co/music/preview/mixkit-a-very-happy-christmas-897.mp3',
      'coverurl':'https://i.ytimg.com/vi/HGaf0BAC1hI/hqdefault.jpg'
    },
    {
      'title' : 'Complicated',
      'Singer' : 'by Arulo',
      'url' :'https://assets.mixkit.co/music/preview/mixkit-complicated-281.mp3',
      'coverurl':'https://i.ytimg.com/vi/kO-vqyASXAM/maxresdefault.jpg'
    }
  ];


  //setting the player UI data
  String currentTitle = "";
  String currentCover = "";
  String currentSinger = "";
  String currentSong = "";
  String _fileFullPath = "";
  IconData iconData = Icons.play_arrow;
  bool isLoading = false;
  bool isVisible = false;
  late Dio dio ;
  int progress = 0;

  AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;

  Duration duration = new Duration();
  Duration position = new Duration();

  void playMusic(String url) async{

    if(isPlaying && currentSong !=url){
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if(result == 1){
        setState(() {
          isVisible = true;
          currentSong = url;
        });
      }
    }else if(!isPlaying){
      int result = await  audioPlayer.play(url);
      if(result == 1){
        setState(() {
          isPlaying = true;
          iconData = Icons.pause;
          isVisible = true;
        });
      }
    }

    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position  = event;
      });
    });


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dio = Dio();
  }

  Future<List<Directory>?> _getExternalStoragePath(){
    return p.getExternalStorageDirectories(type: p.StorageDirectory.music);
  }

  Future _downloadAndSaveFileToStorage(String urlPath, String fileName) async{
    /*ProgressDialog pd = ProgressDialog(context: context);
    await pd.show(max: 100, msg: 'Downloading....');*/

    try{
      final dirList = await _getExternalStoragePath();
      final path = dirList![0].path;
      final file =  File('$path/$fileName');
      await dio.download(urlPath, file.path,
       onReceiveProgress: (rec, total){
          setState(() {
            isLoading = true;
            progress = ((rec/total)*100).toInt();
            print(progress);
           // pd.update(value: progress);
            // progressDialog.update(
            //     msg: 'Please wait : $progress',
            //     value: 0);
          });
       });

    //  pd.close();
      _fileFullPath =file.path;
    }catch (e){
      print(e);
    }

    setState(() {
      isLoading =false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                itemCount: musicList.length,
                  itemBuilder: (context, index) => customListTile(
                    onTap: () {
                      setState(() {
                        playMusic(musicList[index]['url']);
                        currentTitle = musicList[index]['title'];
                        currentCover = musicList[index]['coverurl'];
                        currentSinger = musicList[index]['Singer'];
                      });
                    },
                    onPressed: (){
                      _downloadAndSaveFileToStorage(musicList[index]['url'], musicList[index]['title']+'.mp3');
                    },
                      title:  musicList[index]['title'],
                      singer: musicList[index]['Singer'],
                      cover: musicList[index]['coverurl'],

                  ),
              ),

          ),
          Visibility(
            visible: isVisible,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[950],
                boxShadow: [
                   BoxShadow(
                      color: Color(0x55212121),
                     blurRadius: 8.0,

                   ),
                ],
              ),
              child: Column(
                children: [
                  Slider.adaptive(
                    value: position.inSeconds.toDouble(),
                    min: 0.0,
                    max: duration.inSeconds.toDouble(),
                    onChanged: (value){},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0,left: 12.0,right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      Container(
                        height: 60.0,
                        width: 60.0,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(currentCover),
                          radius: 40.0,
                        ),
                      ),
                      SizedBox(width:16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentTitle,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              currentSinger,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if(isPlaying){
                              audioPlayer.pause();
                              setState(() {
                                iconData = Icons.play_arrow;
                                isPlaying= false;
                              });
                            }else{
                              audioPlayer.resume();
                              setState(() {
                                iconData = Icons.pause;
                                isPlaying = true;
                              });
                            }
                          },
                          icon: Icon(
                            iconData,
                            color: Colors.white,
                          ),
                        iconSize: 42.0,
                      ),
                    ],),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
