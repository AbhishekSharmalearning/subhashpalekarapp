import 'package:SPNF/src/ui/video/video_streaming_page.dart';
import 'package:SPNF/utils/widgets.dart';
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';


class ListDetailPage extends StatefulWidget {
  final List listHeading;
  final String videoTitle;

  const ListDetailPage({
    Key? key,
    @PathParam() required this.videoTitle,
    @PathParam() required this.listHeading
  }) : super(key: key);

  @override
  State<ListDetailPage> createState() => _ListDetailPageState();

}


class _ListDetailPageState extends State<ListDetailPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        child: ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(widget.videoTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade600,
              ),),
            ),
            for (int i = 0; i < widget.listHeading.length; i++)
              VideoTitleTile(
                videoTitle : widget.listHeading[i]['title'],
                onTileTap : () => Navigator.of(context,rootNavigator: true).push(
                  MaterialPageRoute(
                    builder: (context) => VideoStreamingPage(
                        youtubeId: widget.listHeading[i]['youtubevid']
                    ),
                  ),
                ),
              ),
          ],

        ),
        decoration: BoxDecoration(
          color: const Color(0xff7c94b6),
          image: new DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
            image: new NetworkImage('https://images.unsplash.com/photo-1622310505762-a813a1c2e0bf?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8Z3JlZW4lMjBjb2xvdXJ8ZW58MHx8MHx8&ixlib=rb-1.2.1&w=1000&q=80',),
          ),
        ),
      ),
    );
  }
}

