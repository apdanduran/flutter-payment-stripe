
import 'package:flutterapp/model/ilan.dart';
import 'package:flutterapp/model/konusma.dart';
import 'package:flutterapp/model/mesaj.dart';
import 'package:flutterapp/model/user.dart';

abstract class DBBase {
  Future<bool> saveUser(User user);
  Future<User> readUser(String userID);
  Future<bool> updateProfilFoto(
      String userID, String randomSayi, Ilan kaydedilecekIlan);
  Future<List<Ilan>> getAllUser();
  Stream<List<Mesaj>> getMessages(String currentUserID, String konusulanUserID);
  Future<bool> saveMessage(Mesaj kaydedilecekMesaj);
  Future<List<Konusma>> getAllConversations(String userID);
}
