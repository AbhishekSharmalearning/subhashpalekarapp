import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:subhashpalekarapp/utils/Constants.dart';
import 'package:subhashpalekarapp/utils/NoInternet.dart';
import 'package:subhashpalekarapp/utils/connectionStatusSingleton.dart';
import 'my_audio_list.dart';
import 'my_youtube_video_list.dart';

class MultimediaList extends StatefulWidget {
  const MultimediaList({Key? key}) : super(key: key);

  @override
  _MultimediaListState createState() => _MultimediaListState();
}

class _MultimediaListState extends State<MultimediaList> {

  String choiceValue ="";
  int index =0;

  Widget screens(int index) {
    switch (index){
      case 0:
        return MyYoutubeVideoList(choiceValue: choiceValue);
        break;
      case 1:
        return MyAudioList(choiceValue: choiceValue);
        break;
      default:
        return MyYoutubeVideoList(choiceValue: choiceValue);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<ConnectionStatusSingleton>(context,listen: false).startMonitoring();
  }



  @override
  Widget build(BuildContext context) {
    final item = <Widget>[
      Icon(Icons.video_collection,size: 30),
      Icon(Icons.audiotrack,size: 30)
    ];
    AudioPlayer audioPlayer = AudioPlayer();
    return Scaffold(
      extendBody: true,
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
    );
  }


  choiceAction(String choice) {
    setState(() {
      choiceValue = choice;
    });
  }

  Widget pageUI(){
    return Consumer<ConnectionStatusSingleton>(
        builder: (context,model, child){
          if(model.isOnline !=null){
            return model.isOnline
                ? SafeArea(child: screens(index)
            ) : SafeArea(child: NoInternet());
          }
          return Container(
            child: Center(
              child:  CircularProgressIndicator(),
            ),
          );
        },
    );
  }
}
