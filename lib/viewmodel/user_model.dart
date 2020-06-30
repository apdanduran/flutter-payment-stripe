import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutterapp/locator.dart';
import 'package:flutterapp/model/ilan.dart';
import 'package:flutterapp/model/konusma.dart';
import 'package:flutterapp/model/mesaj.dart';
import 'package:flutterapp/model/user.dart';
import 'package:flutterapp/repository/user_repository.dart';
import 'package:flutterapp/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  User _user;
  String emailHataMesaji;
  String sifreHataMesaji;

  User get user => _user;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  UserModel() {
    currentUser();
  }

  @override
  Future<User> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      return _user;
    } catch (e) {
      debugPrint("Viewmodeldeki current user hata: " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _user = null;
      return sonuc;
    } catch (e) {
      debugPrint("Viewmodeldeki signOut user hata: " + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String sifre) async {
    if (_emailSifreKontrol(email, sifre)) {
      try {
        state = ViewState.Busy;
        _user =
            await _userRepository.createUserWithEmailAndPassword(email, sifre);
        return _user;
      } finally {
        state = ViewState.Idle;
      }
    } else
      return null;
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String sifre) async {
    try {
      if (_emailSifreKontrol(email, sifre)) {
        state = ViewState.Busy;
        _user = await _userRepository.signInWithEmailAndPassword(email, sifre);
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailSifreKontrol(String email, String sifre) {
    var sonuc = true;
    if (sifre.length < 6) {
      sifreHataMesaji = "En az 6 karakter olmali";
      sonuc = false;
    } else
      sifreHataMesaji = null;
    if (!email.contains('@')) {
      emailHataMesaji = "Geçersiz email adresi";
      sonuc = false;
    } else
      emailHataMesaji = null;
    return sonuc;
  }

  uploadFile(String userID, File profilFoto, Ilan kaydedilecekIlan) async {
    var indirmeLinki =
        await _userRepository.uploadFile(userID, profilFoto, kaydedilecekIlan);
    return indirmeLinki;
  }

  Future<List<Ilan>> getAllUser() async {
    var tumKullaniciListesi = await _userRepository.getAllUser();
    return tumKullaniciListesi;
  }

  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserID) {
    return _userRepository.getMessages(currentUserID, sohbetEdilenUserID);
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    return await _userRepository.saveMessage(kaydedilecekMesaj);
  }

  Future<List<Konusma>> getAllConversations(String userID) {
    return _userRepository.getAllConversations(userID);
  }
}
