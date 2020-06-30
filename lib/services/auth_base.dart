import 'package:flutterapp/model/user.dart';

abstract class AuthBase {
  Future<bool> signOut();
  Future<User> currentUser();
  Future<User> signInWithEmailAndPassword(String email, String sifre);
  Future<User> createUserWithEmailAndPassword(String email, String sifre);
}
