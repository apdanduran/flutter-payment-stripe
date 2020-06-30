import 'package:cloud_firestore/cloud_firestore.dart';

class Ilan {
  final String userID;
  String postURL;
  final String fiyat;
  final String aciklama;
  final DateTime date;

  Ilan({this.userID, this.postURL, this.fiyat, this.aciklama, this.date});
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'postURL': postURL,
      'fiyat': fiyat,
      'aciklama': aciklama,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  Ilan.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        postURL = map['postURL'],
        fiyat = map['fiyat'],
        aciklama = map['aciklama'],
        date = (map['date'] as Timestamp).toDate();

  @override
  String toString() {
    return 'User{userID: $userID, postURL: $postURL, fiyat: $fiyat, aciklama: $aciklama, date: $date }';
  }
}
