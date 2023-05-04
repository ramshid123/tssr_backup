import 'package:firebase_storage/firebase_storage.dart';

class StorageService{
  final instance = FirebaseStorage.instance;

  StorageService(){
    instance.setMaxUploadRetryTime(Duration(seconds: 20));
    instance.setMaxDownloadRetryTime(Duration(seconds: 20));
  }
}