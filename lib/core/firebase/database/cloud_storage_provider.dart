import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final firebaseCloudStorageProvider = Provider<FirebaseStorageProvider>((ref) {
  return FirebaseStorageProvider(
    storage: FirebaseStorage.instance,
  );
});

class FirebaseStorageProvider {
  final FirebaseStorage storage;

  FirebaseStorageProvider({
    required this.storage,
  });

  Future<String> uploadStorage(XFile file, String table) async {
    try {
      final Completer<String> _completer = Completer<String>();

      final name = file.path.split('/').last;
      final storageRef = storage.ref('$table/$name');
      final uploadTask = storageRef.putFile(File(file.path));

      uploadTask.snapshotEvents.listen((taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.success:
            _completer.complete(await storageRef.getDownloadURL());
            break;
          case TaskState.paused:
            break;
          case TaskState.running:
            break;
          case TaskState.canceled:
            _completer.complete('');
            break;
          case TaskState.error:
            _completer.complete('');
            break;
        }
      });

      return await _completer.future;
    } catch (e) {
      return '';
    }
  }
}
