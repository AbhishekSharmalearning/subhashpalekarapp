import 'package:SPNF/src/ui/video/list_detail_page.dart';
import 'package:SPNF/utils/widgets.dart';
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:SPNF/utils/Constants.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:SPNF/utils/PreferenceUtils.dart';
import 'package:SPNF/utils/FireStoreQuery.dart';

class MyYoutubeVideoPage extends StatefulWidget {

  final String choiceValue;
  const MyYoutubeVideoPage({
    Key? key,
    required this.choiceValue}
    ) : super(key: key);

  @override
  _MyYoutubeVideoPageState createState() => _MyYoutubeVideoPageState();
}

class _MyYoutubeVideoPageState extends State<MyYoutubeVideoPage> {

  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isGetDataFromServer = true;
  List youtubeVideoList =[];
  List updated_List = [];
  List updatedListTemp = [];
  List cache_List = [];
  List cacheListTemp = [];
  List videoListTemp = [];
  List filterList =[];

  @override
  void initState() {
    if(PreferenceUtils.getBool('fromServer') != null){
      isGetDataFromServer =PreferenceUtils.getBool('fromServer')!;
    }else{
      isGetDataFromServer =isGetDataFromServer;
    }
    getVideoList().then((List list) {
      setState(() {
        youtubeVideoList = list;
      });
    });

    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    setState(() {
      filterList.clear();
      if(widget.choiceValue.isNotEmpty && widget.choiceValue != 'All') {
        filterList.addAll(
            youtubeVideoList.where((e) => e['language_code'] == widget.choiceValue)
                .toList());
      }else{
        filterList.addAll(youtubeVideoList);
      }
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            for (int i = 0; i < filterList.length; i++)
              VideoTitleTile(
                  videoTitle : filterList[i]['heading'],
                  onTileTap : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListDetailPage(
                              listHeading: filterList[i]['list']
                          ),
                      ),
                  ),
              ),
          ],
        ),
      ),
    );
  }

  Future<List> getVideoList() async{
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
            if(updated_List[i]['media_type']== 'V'){
              updatedListTemp.add(updated_List[i]);
            }
          }
          cache_List = querySnapshot.docs.map((doc) => doc.data()).toList();
          for(var i=0; i<updated_List.length;i++){
            if(updated_List[i]['media_type']== 'V'){
              cacheListTemp.add(updated_List[i]);
            }
          }
          videoListTemp = new List.from(cacheListTemp)..addAll(updatedListTemp);
        }else{
          updated_List = querySnapshot.docs.map((doc) => doc.data()).toList();
          for(var i=0; i<updated_List.length;i++){
            if(updated_List[i]['media_type']== 'V'){
              videoListTemp.add(updated_List[i]);
            }
          }
        }
      }).catchError((e) => print("error fetching data: $e"));
    }catch(e){
      print(e);
    }
    return videoListTemp;
  }


  Future<Timestamp> convertStringToDate(String dateTime) async {
    DateTime dt = DateTime.parse(dateTime);
    Timestamp myTimeStamp = Timestamp.fromDate(dt);
    return myTimeStamp;
  }
}
