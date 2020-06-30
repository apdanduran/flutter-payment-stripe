import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterapp/services/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  StorageReference _storageReference;

  @override
  Future<String> uploadFile(
      String userID, String rastgeleSayi, File yuklenecekDosya) async {
    _storageReference =
        _firebaseStorage.ref().child(userID).child(rastgeleSayi);
    var uploadTask = _storageReference.putFile(yuklenecekDosya);

    var url = await (await uploadTask.onComplete).ref.getDownloadURL();
    print("yüklenen photo id :" + url);
    return url;
  }
}
