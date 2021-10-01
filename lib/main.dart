import 'package:flutter/material.dart';
import 'package:subhashpalekarapp/src/myapp.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subhashpalekarapp/utils/connectionStatusSingleton.dart';

void main() async{
  await GetStorage.init();
  runApp(MyApp());
}



