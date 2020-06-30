import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterapp/model/user.dart';
import 'package:flutterapp/services/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String sifre) async {
    AuthResult sonuc = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: sifre);
    return _userFromFirebase(sonuc.user);
  }

  @override
  Future<User> currentUser() async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      return _userFromFirebase(user);
    } catch (e) {
      print("HATA CURRENT USER" + e.toString());
      return null;
    }
  }

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) return null;
    return User(userID: user.uid, email: user.email);
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String sifre) async {
    AuthResult sonuc = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: sifre);
    return _userFromFirebase(sonuc.user);
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();

      return true;
    } catch (e) {
      print("sign out hata:" + e.toString());
      return false;
    }
  }
}
