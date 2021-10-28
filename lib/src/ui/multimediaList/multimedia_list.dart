import 'package:SPNF/src/ui/audio/my_audio_list.dart';
import 'package:SPNF/src/ui/video/my_youtube_video_page.dart';
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
  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];


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
    if(status == PermissionStatus.granted){
      datacount.write(Constants.PERMISSION, true);
    }else{
      datacount.write(Constants.PERMISSION, false);
    }

    return status == PermissionStatus.granted;
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_selectedIndex].currentState!.maybePop();

        print(
            'isFirstRouteInCurrentTab: ' + isFirstRouteInCurrentTab.toString());

        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
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
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          showSelectedLabels: true,
          showUnselectedLabels: false,

          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.video_collection,
                color: Colors.white,
              ),
              label: 'Video',
              activeIcon: Icon(
                Icons.video_collection,
                color: Colors.green,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.audiotrack,
                color: Colors.white,
              ),
              label: 'Audio',
              activeIcon: Icon(
                Icons.audiotrack,
                color: Colors.green,
              ),
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },

        ),
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
          ],
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    if(choiceValue.isEmpty){
      choiceValue = Constants.DEFAULTLANGUAGE;
    }else{
      choiceValue = choiceValue;
    }
    return {
      '/': (context) {
        return [
          MyYoutubeVideoPage(choiceValue: choiceValue),
          MyAudioList(choiceValue: choiceValue),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);
    var route_builder_temp;
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          route_builder_temp = routeBuilders[routeSettings.name];
          if(route_builder_temp!=null){
            return MaterialPageRoute(
              builder: (context) => route_builder_temp(context),
            );
          }
        },
      ),
    );
  }


  choiceAction(String choice) {
    setState(() {
      choiceValue = choiceValue.isNotEmpty ? choice : Constants.DEFAULTLANGUAGE;;
    });
  }



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
