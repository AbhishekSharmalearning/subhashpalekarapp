import 'package:SPNF/router/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:SPNF/src/myapp.dart';
import 'package:SPNF/utils/PreferenceUtils.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceUtils.init();
  await Firebase.initializeApp();
  await GetStorage.init();
  /*runApp(MyApp());*/
  runApp(AppWidget());


  
}

class AppWidget extends StatelessWidget {
  AppWidget({Key? key}) : super(key: key);
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SPNF',
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}




