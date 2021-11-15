
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:SPNF/src/myapp.dart';
import 'package:SPNF/utils/PreferenceUtils.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  await Firebase.initializeApp();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
  /*runApp(MyApp());*/
}





