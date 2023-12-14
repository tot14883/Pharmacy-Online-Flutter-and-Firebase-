import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseRealTimeProvider = Provider<FirebaseRealTime>((ref) {
  return FirebaseRealTime(
    realTime: FirebaseDatabase.instance,
  );
});

class FirebaseRealTime {
  final FirebaseDatabase realTime;

  FirebaseRealTime({
    required this.realTime,
  });

  DatabaseReference ref(String path) {
    return realTime.ref(path);
  }
}
