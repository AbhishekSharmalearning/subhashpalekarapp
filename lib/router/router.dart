import 'package:SPNF/src/myapp.dart';
import 'package:SPNF/src/ui/audio/my_audio_list.dart';
import 'package:SPNF/src/ui/video/list_detail_page.dart';
import 'package:SPNF/src/ui/video/my_youtube_video_page.dart';
import 'package:SPNF/src/ui/video/video_streaming_page.dart';
import 'package:auto_route/auto_route.dart';


@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(path: '/', page: MyApp, children: [
      AutoRoute(
        path: 'video',
        name: 'videosRouter',
        page: MyYoutubeVideoPage,
        children: [
          AutoRoute(
            path: ':choiceValue',
            page: MyYoutubeVideoPage,
          ),
          AutoRoute(
            path: ':listHeading',
            page: ListDetailPage,
          ),
          AutoRoute(
            path: ':youtubeId',
            page: VideoStreamingPage,
          ),

        ],
      ),
      AutoRoute(
        path: 'audio',
        name: 'audiosRouter',
        page: MyAudioList,
      ),
    ]),
  ],
)
class $AppRouter {}