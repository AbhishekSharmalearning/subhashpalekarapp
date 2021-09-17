import 'package:flutter/material.dart';
import '../src/ui/multimedia_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: MultimediaList(),
      ),
    );
  }
}


