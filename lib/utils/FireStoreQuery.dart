import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:SPNF/utils/Constants.dart';
import 'package:SPNF/utils/PreferenceUtils.dart';

extension FirestoreQueryExtension on Query {
  Future<QuerySnapshot> getSavy() async {

    List timeStampList = [];
    try {
      QuerySnapshot qs = await this.get(GetOptions(source: Source.cache));
      if (qs.docs.isEmpty) {
        qs = await this.get(GetOptions(source: Source.server));
        qs.docs.forEach((res) {
          timeStampList.add(res.get('timeStamp'));
        });
        await PreferenceUtils.setString(Constants.SAVEDTIMESTAMP, saveTimeStampInDateString(timeStampList.asMap()[0]));

        return qs;
      }else {
        return qs;
      }

    } catch (_) {
      return this.get(GetOptions(source: Source.server));
    }
  }


  Future<QuerySnapshot> getSavyMultimedia() async {
    List timeStampList = [];
    try {
      QuerySnapshot qs = await this.get(GetOptions(source: Source.cache));
      if (qs.docs.isEmpty) {
        qs = await this.get(GetOptions(source: Source.server));
        qs.docs.forEach((res) {
          timeStampList.add(res.get('timeStamp'));
        });
        await PreferenceUtils.setString(Constants.SAVEDMULTIMEDIATIME, saveTimeStampInDateString(timeStampList.asMap()[0]));
        return qs;
      }else {
        return qs;
      }

    } catch (_) {
      return this.get(GetOptions(source: Source.server));
    }
  }

}

String saveTimeStampInDateString(asMap) {
  Timestamp t = asMap;
  DateTime d = t.toDate();
  print(d.toString());
  return d.toString();
}