import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  final String userID;
  String email;
  String userName;
  String profilURL;
  DateTime createdAt;
  DateTime updateddAt;
  String il;
  String ilce;
  String bio;
  int seviye;

  User({@required this.userID, @required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName':
          userName ?? email.substring(0, email.indexOf('@')) + randomSayiUret(),
      'profilURL': profilURL ??
          'https://image.freepik.com/free-vector/panda-cartoon-style_119631-183.jpg',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updateddAt ?? FieldValue.serverTimestamp(),
      'seviye': seviye ?? 1,
      'il': il,
      'ilce': ilce,
      'bio': bio ?? "",
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profilURL = map['profilURL'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updateddAt = (map['updatedAt'] as Timestamp).toDate(),
        seviye = map['seviye'],
        il = map['il'],
        ilce = map['ilce'],
        bio = map['bio'];

  @override
  String toString() {
    return 'User{userID: $userID, email: $email, userName: $userName, profilURL: $profilURL,  createdAt: $createdAt, updateddAt: $updateddAt, seviye: $seviye, il: $il, ilce: $ilce, bio: $bio }';
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(99999);
    return rastgeleSayi.toString();
  }
}
