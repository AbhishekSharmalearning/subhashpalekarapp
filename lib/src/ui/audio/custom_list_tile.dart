import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/percent_indicator.dart';




Widget customListTile({required String title, required String  singer, onTap,onPressed,required bool filePath,required int progress }
){
  bool isDownloaded = false;
  bool isVisible = false;

  if(progress > 0 && progress < 100){
    isVisible = filePath;
  }else if(progress == 100){
    isDownloaded = true;
  }


  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.only(bottom: 8.0,left: 12.0,right: 12.0),
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
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                      singer,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            getMyWidget(isVisible, isDownloaded,progress,onPressed),
          ],
      ),
    ),
  );
}

Widget getMyWidget(bool isVisible,bool isDownloaded,int progress, onPressed){
  if(isVisible && !isDownloaded){
    return Visibility(
      visible: isVisible,
        child: circularPercentageBar(progress)
    );
  }else{
    return Visibility(
      visible: !isDownloaded,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: IconButton(
            icon: Icon(Icons.download),
            onPressed: onPressed
        ),
      ),
    );
  }
}




Widget circularPercentageBar(int progress){
  return new CircularPercentIndicator(
    radius: 40.0,
    lineWidth: 3.0,
    animation: true,
    percent: progress/100,
    center: Text(
      progress.toString() + "%",
      style: TextStyle(
          fontSize: 10.0,
          fontWeight: FontWeight.w600,
          color: Colors.white),
    ),
    backgroundColor: Colors.grey,
    circularStrokeCap: CircularStrokeCap.round,
    progressColor: Colors.redAccent,
  );
}

