import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:subhashpalekarapp/utils/connectionStatusSingleton.dart';
import '../src/ui/multimedia_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (context) => ConnectionStatusSingleton(),
              child: MultimediaList(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData.dark(),
          home: Scaffold(
            body: MultimediaList(),
          ),
        ),
    );

     MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: MultimediaList(),
      ),
    );
  }
}


