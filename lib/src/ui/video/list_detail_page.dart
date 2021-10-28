import 'package:SPNF/src/ui/video/video_streaming_page.dart';
import 'package:SPNF/utils/widgets.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

class ListDetailPage extends StatefulWidget {
  final List listHeading;

  const ListDetailPage({
    Key? key,
    @PathParam() required this.listHeading
  }) : super(key: key);

  @override
  State<ListDetailPage> createState() => _ListDetailPageState();
}

class _ListDetailPageState extends State<ListDetailPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            for (int i = 0; i < widget.listHeading.length; i++)
              VideoTitleTile(
                videoTitle : widget.listHeading[i]['title'],
                onTileTap : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoStreamingPage(
                        youtubeId: widget.listHeading[i]['youtubevid']
                    ),
                  ),
                ),
              ),
      /*      Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: widget.listHeading.length,
                  itemBuilder: (context,index){
                    for(int i=0;i<widget.listHeading.length;i++){
                      heading = widget.listHeading[i]['title'];
                    }
                    return GestureDetector(
                      child: Container(
                        height: 70,
                        child: Card(
                          elevation: 10,
                          child: Chip(
                            label: Text(heading),
                            shadowColor: Colors.blue,
                            backgroundColor: Colors.green,
                            elevation: 5,
                            autofocus: true,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

