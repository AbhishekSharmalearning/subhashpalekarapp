import 'package:cloud_firestore/cloud_firestore.dart';

class DateStringToTimeStamp{

  Future<Timestamp> convertStringToDate(String dateTime) async {
    DateTime dt = DateTime.parse(dateTime);
    Timestamp myTimeStamp = Timestamp.fromDate(dt);
    return myTimeStamp;
  }
}