import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/percent_indicator.dart';




Widget customListTile({required String title, required String  singer,
  onTap,onPressed,required List fileList,
  required int progress,required int selectedIndex, required int index }
){

  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0,top: 4.0),
      child: Card(
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,left: 12.0,right: 12.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 70.0,
                  width: 70.0,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/Subhash_Palekar.jpg"),
                    radius: 25.0,
                  ),
                ),
                SizedBox(width: 15.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.purple[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                          singer,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                getMyWidget(progress,onPressed,fileList,selectedIndex,index,title),
              ],
          ),
          decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.2),
                  BlendMode.dstATop),
              image: AssetImage('assets/veganicfarming.png'),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget getMyWidget(int progress, onPressed, List fileList, int selectedIndex, int index, String title){
  if(selectedIndex == -1){
    if(fileList.length > 0){
      if(fileList.contains("/storage/emulated/0/Download/" + title +".mp3")){
        return Container(
          child: ShowEmptyIcon(),
        );
      }else{
        return Container(
          child: ShowDefaultIcon(onPressed),
        );
      }
    }else{
      return Container(
        child: ShowDefaultIcon(onPressed),
      );
    }
  }else{
    if(selectedIndex!=index){
      if(fileList.contains("/storage/emulated/0/Download/" + title +".mp3")){
        return Container(
          child: ShowEmptyIcon(),
        );
      }else{
        return Container(
          child: ShowDefaultIcon(onPressed),
        );
      }
    }else{
      if(progress==100){
        return Container(
          child: ShowEmptyIcon(),
        );
      }else{
        return Container(
          child: circularPercentageBar(progress),
        );
      }
    }
  }
}

Widget ShowEmptyIcon() {
  return Container();
}

Widget ShowDefaultIcon(onPressed){
  return Padding(
      padding:  const EdgeInsets.only(right: 1.0),
    child: IconButton(
      color: Colors.red[800],
        icon: Icon(Icons.download),
        onPressed: onPressed
    ),
  );
}


Widget circularPercentageBar(int progress){
  return Padding(
    padding: const EdgeInsets.all(1.0),
    child: new CircularPercentIndicator(
      radius: 40.0,
      lineWidth: 3.0,
      animation: true,
      percent: progress/100,
      center: Text(
        progress.toString() + "%",
        style: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
            color: Colors.red[900]),
      ),
      backgroundColor: Colors.blueGrey,
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.red,
    ),
  );
}

