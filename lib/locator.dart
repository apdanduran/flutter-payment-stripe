import 'package:flutterapp/repository/user_repository.dart';
import 'package:flutterapp/services/firebase_auth_service.dart';
import 'package:flutterapp/services/firebase_storeage_service.dart';
import 'package:flutterapp/services/firestore_db_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirebaseStorageService());
}
