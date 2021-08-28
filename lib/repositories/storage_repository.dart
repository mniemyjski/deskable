import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';

class StorageRepository {
  Future<String> uploadToFirebaseStorage({
    required Uint8List uint8List,
    required String path,
  }) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    // String filePath = folderName == 'accounts' ? '$folderName/$uid/avatar/$uid' : '$folderName/$name';

    try {
      await storage.ref(path).putData(uint8List);
    } on firebase_core.FirebaseException catch (e) {}

    return await storage.ref(path).getDownloadURL();
  }
}
