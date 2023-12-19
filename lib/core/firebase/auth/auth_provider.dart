// Import the firebase_core and cloud_firestore plugin
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseAuthProvider = Provider<FirebaseAuthProvider>((ref) {
  return FirebaseAuthProvider(
    fireAuth: FirebaseAuth.instance,
  );
});

/// this is a wrapper class for FirebaseFirebaseDatabase.
class FirebaseAuthProvider {
  final FirebaseAuth fireAuth;

  FirebaseAuthProvider({
    required this.fireAuth,
  });

  Future<UserCredential> createEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await fireAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential;
  }

  Future<UserCredential> singInEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await fireAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential;
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await fireAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final user = fireAuth.currentUser;

      await user?.updatePassword(newPassword).then((_) {
        print('this two');

        return true;
      }).catchError((error) {
        return false;
      });

      print('this one');
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await fireAuth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}
