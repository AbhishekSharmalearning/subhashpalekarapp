import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:SPNF/src/ui/audio/custom_list_tile.dart';
import 'package:SPNF/utils/Constants.dart';
import 'package:SPNF/utils/FireStoreQuery.dart';
import 'package:SPNF/utils/PreferenceUtils.dart';


class MyAudioList extends StatefulWidget {

  final String choiceValue;

  MyAudioList({Key? key, required this.choiceValue}) : super(key: key);

  @override
  _MyAudioListState createState() => _MyAudioListState();
}

class _MyAudioListState extends State<MyAudioList> {

  bool downloading = false;
  List audioList =[];
  List updated_List = [];
  List cache_List = [];
  List updatedListTemp = [];
  List cacheListTemp = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String currentTitle = "";
  String currentCover = "";
  String currentSinger = "";
  String currentSong = "";
  IconData iconData = Icons.play_arrow;
  bool isLoading = false;
  bool isVisible = false;
  late Dio dio ;
  late final savePath;
  int _progress = 0;
  List filterList =[];
  late final file;
  final datacount = GetStorage();
  AudioPlayer audioPlayer = new AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;
  bool isGetDataFromServer = true;
  Duration duration = new Duration();
  Duration position = new Duration();




  @override
  void initState() {
    getMusicList().then((List list) {
      setState(() {
        audioList = list;
      });
    });
    super.initState();
    notificationBuilder();
    dio = Dio();
  }


  Future<void> _download(String urlPath, String fileName) async {
    final dir = await _getDownloadDirectory();
    final isPermissionStatusGranted = await datacount.read(Constants.PERMISSION);
    if (!isPermissionStatusGranted && dir?.path == null) {
      // handle the scenario when user declines the permissions
    } else {
      var value = "";
       if(dir?.path.isEmpty == true){
         value = "";
       } else {
         value = dir!.path;
       }

      savePath = path.join(value, fileName);
      datacount.write(Constants.FILEPATH, value);
      await _startDownload(savePath,urlPath);

    }
  }

  Future<void> _startDownload(String savePath, String urlPath) async {
    Map<String, dynamic> result = {
      'isSuccess': false,
      'filePath': null,
      'error': null,
    };

    try {
      final response = await dio.download(
          urlPath,
          savePath,
          onReceiveProgress: _onReceiveProgress
      );
      result['isSuccess'] = response.statusCode == 200;
      result['filePath'] = savePath;
    } catch (ex) {
      result['error'] = ex.toString();
    } finally {
      await _showNotification(result);
    }
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      setState(() {
        _progress = (received / total * 100).toStringAsFixed(0) as int;
        print('progress downloading $_progress');
      });
    }
  }

  Future<Directory?> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }
    return await getApplicationDocumentsDirectory();
  }



  bool isExist(int index){
    return File(datacount.read(Constants.FILEPATH)!=null ?  datacount.read(Constants.FILEPATH) + "/" + filterList[index]['title'] + ".mp3" : "").existsSync();

  }

  @override
  Widget build(BuildContext context) {
     setState(() {
      filterList.clear();
      if(widget.choiceValue.isNotEmpty && widget.choiceValue != 'All') {
        filterList.addAll(
            audioList.where((e) => e['language_code'] == widget.choiceValue)
                .toList());
      }else{
        filterList.addAll(audioList);
      }
     });
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filterList.length,
                  itemBuilder: (context, index) => customListTile(
                    onTap: () {
                      setState(() {
                        if(isExist(index)){
                          playMusic(datacount.read(Constants.FILEPATH) + "/" + filterList[index]['title'] + ".mp3");
                        }else{
                          playMusic(filterList[index]['audio_url']);
                        }
                        currentTitle = filterList[index]['title'];
                        currentSinger = filterList[index]['audio_by'];
                      });
                    },
                    onPressed: (){
                      _download(filterList[index]['audio_url'], filterList[index]['title']+'.mp3');
                    },
                      title:  filterList[index]['title'],
                      singer: filterList[index]['audio_by'],
                      filePath : isExist(index) ,
                      progress :  _progress,
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
                        height: 50.0,
                        width: 50.0,
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/Subhash_Palekar.jpg"),
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

  Future<List> getMusicList() async{
    try{
      CollectionReference _collectionRef = FirebaseFirestore.instance.collection('data');
      QuerySnapshot querySnapshot = await _collectionRef.orderBy('timeStamp',descending: true).getSavyMultimedia();
      var timeStamps= await convertStringToDate(PreferenceUtils.getString(Constants.SAVEDMULTIMEDIATIME)!);
      await _collectionRef
          .orderBy('timeStamp',descending: true)
          .where(
          'timeStamp',isGreaterThan:timeStamps)
          .getSavyMultimedia().then((event) {
        if (event.docs.isNotEmpty) {
          updated_List = event.docs.map((doc) => doc.data()).toList();
          for(var i=0; i<updated_List.length;i++){
            if(updated_List[i]['media_type']== 'A'){
              updatedListTemp.add(updated_List[i]);
            }
          }
          cache_List = querySnapshot.docs.map((doc) => doc.data()).toList();
          for(var i=0; i<updated_List.length;i++){
            if(updated_List[i]['media_type']== 'A'){
              cacheListTemp.add(updated_List[i]);
            }
          }
          audioList = new List.from(cacheListTemp)..addAll(updatedListTemp);
        }else{
          updated_List = querySnapshot.docs.map((doc) => doc.data()).toList();
          for(var i=0; i<updated_List.length;i++){
            if(updated_List[i]['media_type']== 'A'){
              audioList.add(updated_List[i]);
            }
          }
        }
      }).catchError((e) => print("error fetching data: $e"));
    }catch(e){
      print(e);
    }
    return audioList;
  }

  Future<Timestamp> convertStringToDate(String dateTime) async {
    DateTime dt = DateTime.parse(dateTime);
    Timestamp myTimeStamp = Timestamp.fromDate(dt);
    return myTimeStamp;
  }


  Future<void> _showNotification(Map<String, dynamic> downloadStatus) async {
    final android = AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        priority: Priority.high,
        importance: Importance.max
    );
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(downloadStatus);
    final isSuccess = downloadStatus['isSuccess'];

    await flutterLocalNotificationsPlugin.show(
        0, // notification id
        isSuccess ? 'Success' : 'Failure',
        isSuccess ? 'File has been downloaded successfully!' : 'There was an error while downloading the file.',
        platform,
        payload: json
    );
  }




  /*
  *   MUSIC PLAYER
  * */
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




  /*
  * AFTER SELECTING DOWNLOADED AUDIO FROM NOTIFICATION PLAY
  *
  * */
  Future<void> _onSelectNotification(String json) async {
    final obj = jsonDecode(json);

    if (obj['isSuccess']) {
      OpenFile.open(obj['filePath']);
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('${obj['error']}'),
        ),
      );
    }
  }

  void notificationBuilder() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: (String? json) async {
          _onSelectNotification(json!);
        });
  }
}


