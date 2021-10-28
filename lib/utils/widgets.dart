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
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 100,
            vertical: 20,
          ),
          child: Column(
            children: [
              Text(
                videoTitle,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}