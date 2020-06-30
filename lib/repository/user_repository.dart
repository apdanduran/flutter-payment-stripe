import 'dart:io';
import 'dart:math';

import 'package:flutterapp/locator.dart';
import 'package:flutterapp/model/ilan.dart';
import 'package:flutterapp/model/konusma.dart';
import 'package:flutterapp/model/mesaj.dart';
import 'package:flutterapp/model/user.dart';
import 'package:flutterapp/services/auth_base.dart';
import 'package:flutterapp/services/firebase_auth_service.dart';
import 'package:flutterapp/services/firebase_storeage_service.dart';
import 'package:flutterapp/services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  @override
  Future<User> currentUser() async {
    User _user = await _firebaseAuthService.currentUser();
    return await _firestoreDBService.readUser(_user.userID);
  }

  @override
  Future<bool> signOut() async {
    return await _firebaseAuthService.signOut();
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String sifre) async {
    User _user =
        await _firebaseAuthService.createUserWithEmailAndPassword(email, sifre);
    bool _sonuc = await _firestoreDBService.saveUser(_user);
    if (_sonuc) {
      return await _firestoreDBService.readUser(_user.userID);
    } else
      return null;
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String sifre) async {
    User _user =
        await _firebaseAuthService.signInWithEmailAndPassword(email, sifre);
    return await _firestoreDBService.readUser(_user.userID);
  }

  Future<String> uploadFile(
      String userID, File profilFoto, Ilan kaydedilecekIlan) async {
    int rastgeleSayi = Random().nextInt(99999);
    var profilFotoUrl = await _firebaseStorageService.uploadFile(
        userID, rastgeleSayi.toString(), profilFoto);
    kaydedilecekIlan.postURL = profilFotoUrl.toString();
    await _firestoreDBService.updateProfilFoto(
        userID, rastgeleSayi.toString(), kaydedilecekIlan);
    return profilFotoUrl;
  }

  Future<List<Ilan>> getAllUser() async {
    var tumIlanlar = await _firestoreDBService.getAllUser();
    return tumIlanlar;
  }

  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserID) {
    return _firestoreDBService.getMessages(
      currentUserID,
      sohbetEdilenUserID,
    );
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    return await _firestoreDBService.saveMessage(kaydedilecekMesaj);
  }

  Future<List<Konusma>> getAllConversations(String userID) async {
    return await _firestoreDBService.getAllConversations(userID);
  }
}
