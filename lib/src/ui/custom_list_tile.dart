import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';



Widget customListTile({required String title, required String  singer,
  required String cover, onTap,onPressed,required bool filePath }
){

  bool isVisible = filePath;


  return InkWell(
    onTap: onTap,
    child: Container(
       padding: EdgeInsets.all(8.0),
      child: Row(
          children: [
            Container(
              height: 70.0,
              width: 70.0,
              child: CircleAvatar(
                backgroundImage: NetworkImage(cover),
                radius: 25.0,
              ),
            ),
            SizedBox(width: 15.0),
            Column(
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
            new Spacer(),
            Visibility(
              visible: !isVisible,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: IconButton(
                  icon: Icon(Icons.download),
                  onPressed: onPressed
                ),
              ),
            )
          ],
      ),
    ),
  );
}

