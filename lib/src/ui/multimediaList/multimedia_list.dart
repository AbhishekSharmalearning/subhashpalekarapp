import 'package:SPNF/router/router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:SPNF/utils/dateString_to_timestamp.dart';
import 'package:SPNF/utils/Constants.dart';
import 'package:SPNF/utils/FireStoreQuery.dart';
import 'package:SPNF/utils/PreferenceUtils.dart';
import 'package:SPNF/utils/connectionStatusSingleton.dart';


final languageRef = FirebaseFirestore.instance.collection('data');

class MultimediaList extends StatefulWidget {
  const MultimediaList({Key? key}) : super(key: key);

  @override
  _MultimediaListState createState() => _MultimediaListState();
}

class _MultimediaListState extends State<MultimediaList> {

  String choiceValue ="";
  int index =0;
  List updated_List = [];
  List cache_List = [];
  List languages_List = [];
  bool isGetDataFromServer = true;
  List contacts =[];
  final datacount = GetStorage();

  /*Widget screens(int index) {
    var selectedLang = choiceValue.isNotEmpty ? choiceValue : Constants.DEFAULTLANGUAGE;
    switch (index){
      case 0:
        return MyYoutubeVideoList(choiceValue: selectedLang);
        break;
      case 1:
        return MyAudioList(choiceValue: selectedLang);
        break;
      default:
        return MyYoutubeVideoList(choiceValue: selectedLang);
        break;
    }
  }*/


  @override
  void initState() {
    getPermission();
    getLanguageFinal().then((List list) {
      setState(() {
        contacts = list;
      });
    });

    super.initState();
    Provider.of<ConnectionStatusSingleton>(context,listen: false).startMonitoring();

  }


  Future<bool> getPermission() async {
    final status = await Permission.storage.request();
    if (status == PermissionStatus.granted) {
      print('Permission granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied. Show a dialog and again ask for the permission');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Take the user to the settings page.');
      await openAppSettings();
    }
    datacount.write(Constants.PERMISSION, PermissionStatus.granted);
    return status == PermissionStatus.granted;
  }



  @override
  Widget build(BuildContext context) {
    final item = <Widget>[
      Icon(Icons.video_collection,size: 30),
      Icon(Icons.audiotrack,size: 30)
    ];
    var selectedLang = choiceValue.isNotEmpty ? choiceValue : Constants.DEFAULTLANGUAGE;

    return AutoTabsScaffold(
        appBarBuilder: (_, tabsRouter) => AppBar(
          backgroundColor: Colors.green[900],
          title: Text('SPNF'),
          centerTitle: true,
          leading: const AutoBackButton(),
          actions: [
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context) {
                return languages_List.map((item) => (
                    PopupMenuItem<String>(
                      value: item['id'],
                      child: Text(item['name']),
                    )),
                ).toList();
              },
            ),
          ],
        ),
        routes: [
          VideosRouter(choiceValue: selectedLang),
          AudiosRouter(choiceValue: selectedLang),
        ],
        bottomNavigationBuilder: (_,tabsRouter) {
          return CurvedNavigationBar(
             color: Colors.green.shade900,
             buttonBackgroundColor: Colors.purple,
             backgroundColor: Colors.transparent,
             animationCurve: Curves.easeInOut,
             animationDuration: Duration(milliseconds: 500),
             items: item,
             height: 60,
             index: tabsRouter.activeIndex,
             onTap: tabsRouter.setActiveIndex,
           );
        },
    );

    /*return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text('SPNF'),
        centerTitle: true,
          actions: [
        PopupMenuButton<String>(
          onSelected: choiceAction,
          itemBuilder: (BuildContext context) {
            return languages_List.map((item) => (
               PopupMenuItem<String>(
                 value: item['id'],
                 child: Text(item['name']),
               )),
            ).toList();
          },
        ),
      ],
      ),
      body: pageUI(),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: IconThemeData(color: Colors.white)
        ),
        child: CurvedNavigationBar(
          color: Colors.green.shade900,
          buttonBackgroundColor: Colors.purple,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 500),
          items: item,
          height: 60,
          index: index,
          onTap: (index) => setState(() => this.index = index),
        ),
      ),
    );*/
  }


  choiceAction(String choice) {
    setState(() {
      choiceValue = choice;
    });
  }

 /* Widget pageUI(){
    return Consumer<ConnectionStatusSingleton>(
        builder: (context,model, child){
          return SafeArea(
              child: screens(index)
          );
        },
    );
  }*/


  Future<List> getLanguageFinal() async{
    try{
      CollectionReference _collectionRef = FirebaseFirestore.instance.collection('languages');
      QuerySnapshot querySnapshot = await _collectionRef.orderBy('timeStamp',descending: true).getSavy();
      DateStringToTimeStamp dst= new DateStringToTimeStamp();
      var timeStamps= await dst.convertStringToDate(PreferenceUtils.getString(Constants.SAVEDTIMESTAMP)!);
      await _collectionRef
          .orderBy('timeStamp',descending: true)
          .where(
          'timeStamp',isGreaterThan:timeStamps)
          .getSavy().then((event) {
        if (event.docs.isNotEmpty) {
          updated_List = event.docs.map((doc) => doc.data()).toList();
          cache_List = querySnapshot.docs.map((doc) => doc.data()).toList();
          languages_List = new List.from(cache_List)..addAll(updated_List);
        }else{
          languages_List = querySnapshot.docs.map((doc) => doc.data()).toList();
        }
      }).catchError((e) => print("error fetching data: $e"));
    }catch(e){
      print(e);
    }
    return languages_List;
  }

  Future<Timestamp> convertStringToDate(String dateTime) async {
    DateTime dt = DateTime.parse(dateTime);
    Timestamp myTimeStamp = Timestamp.fromDate(dt);
    return myTimeStamp;
  }



}
