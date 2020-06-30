import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterapp/model/ilan.dart';
import 'package:flutterapp/model/konusma.dart';
import 'package:flutterapp/model/mesaj.dart';
import 'package:flutterapp/model/user.dart';
import 'package:flutterapp/services/database_base.dart';

class FirestoreDBService implements DBBase {
  final Firestore _firebaseDB = Firestore.instance;
  @override
  Future<bool> saveUser(User user) async {
    await _firebaseDB
        .collection("users")
        .document(user.userID)
        .setData(user.toMap());

    DocumentSnapshot _okunanUser =
        await Firestore.instance.document("users/${user.userID}").get();

    Map _okunanUserBilgileriMap = _okunanUser.data;
    User _okunaUserBilgileriNesne = User.fromMap(_okunanUserBilgileriMap);
    print("Yazılan user nesnesi :" + _okunaUserBilgileriNesne.toString());
    return true;
  }

  @override
  Future<User> readUser(String userID) async {
    DocumentSnapshot _okunanUser =
        await _firebaseDB.collection("users").document(userID).get();
    Map<String, dynamic> _okunanUserBilgilerMap = _okunanUser.data;

    User _okunanUserNesnesi = User.fromMap(_okunanUserBilgilerMap);
    print("Okunan user nesnesi :" + _okunanUserNesnesi.toString());

    return _okunanUserNesnesi;
  }

  @override
  Future<bool> updateProfilFoto(
      String userID, String randomSayi, Ilan kaydedilecekIlan) async {
    var ilan = await _firebaseDB
        .collection("ilanlar")
        .document(randomSayi)
        .setData(kaydedilecekIlan.toMap());
    return true;
  }

  @override
  Future<List<Ilan>> getAllUser() async {
    QuerySnapshot querySnapshot = await _firebaseDB
        .collection("ilanlar")
        .orderBy("date", descending: true)
        .getDocuments();

    List<Ilan> tumIlanlar = [];
    for (DocumentSnapshot ilanlar in querySnapshot.documents) {
      Ilan _ilan = Ilan.fromMap(ilanlar.data);
      tumIlanlar.add(_ilan);
    }

    return tumIlanlar;
  }

  @override
  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserID) {
    var snapShot = _firebaseDB
        .collection("konusmalar")
        .document(currentUserID + "--" + sohbetEdilenUserID)
        .collection("mesajlar")
        .orderBy("date")
        .snapshots();
    return snapShot.map(
      (mesajListesi) => mesajListesi.documents
          .map((mesaj) => Mesaj.fromMap(mesaj.data))
          .toList(),
    );
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    var _mesajID = _firebaseDB.collection("konusmalar").document().documentID;
    var _myDocumentID =
        kaydedilecekMesaj.kimden + "--" + kaydedilecekMesaj.kime;
    var _receiverDocumentID =
        kaydedilecekMesaj.kime + "--" + kaydedilecekMesaj.kimden;
    var _kaydedilecekMesajMapYapisi = kaydedilecekMesaj.toMap();
    await _firebaseDB
        .collection("konusmalar")
        .document(_myDocumentID)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_kaydedilecekMesajMapYapisi);

    await _firebaseDB.collection("konusmalar").document(_myDocumentID).setData({
      "konusma_sahibi": kaydedilecekMesaj.kimden,
      "kimle_konusuyor": kaydedilecekMesaj.kime,
      "son_yollanan_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    _kaydedilecekMesajMapYapisi.update("bendenMi", (deger) => false);

    await _firebaseDB
        .collection("konusmalar")
        .document(_receiverDocumentID)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_kaydedilecekMesajMapYapisi);

    await _firebaseDB
        .collection("konusmalar")
        .document(_receiverDocumentID)
        .setData({
      "konusma_sahibi": kaydedilecekMesaj.kime,
      "kimle_konusuyor": kaydedilecekMesaj.kimden,
      "son_yollanan_mesaj": kaydedilecekMesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<List<Konusma>> getAllConversations(String userID) async {
    QuerySnapshot querySnapshot = await _firebaseDB
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .getDocuments();

    List<Konusma> tumKonusmalar = [];
    for (DocumentSnapshot tekKonusma in querySnapshot.documents) {
      Konusma _tekKonusma = Konusma.fromMap(tekKonusma.data);
      tumKonusmalar.add(_tekKonusma);
    }
    return tumKonusmalar;
  }
}
/*
    tumIlanlar =
        querySnapshot.documents.map((e) => Ilan.fromMap(e.data)).toList();
*/
