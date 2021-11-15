import 'package:flutter/material.dart';

class VideoTitleTile extends StatelessWidget {
  final String videoTitle;
  final void Function() onTileTap;

  const VideoTitleTile({
    Key? key,
    required this.videoTitle,
    required this.onTileTap,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTileTap,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(10),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    videoTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Icon(
                    Icons.arrow_forward_ios_outlined,
                  color: Colors.purple,
                  size: 28.0,
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: const Color(0xff7c94b6),
            image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.2),
                  BlendMode.dstATop),
              image: new NetworkImage(
                'https://3z6mv8219w2s2w196j1dkzga-wpengine.netdna-ssl.com/wp-content/uploads/2020/12/Veganic-Farming.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}