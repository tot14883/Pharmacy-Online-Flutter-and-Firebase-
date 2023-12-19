import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/auth/auth_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/authentication/model/request/sign_in_request.dart';

final signInEmailAndPasswordUsecaseProvider =
    Provider<SignInEmailAndPasswordUseCase>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return SignInEmailAndPasswordUseCase(
    ref,
    firebaseAuth,
    fireCloudStore,
    baseSharedPreference,
  );
});

class SignInEmailAndPasswordUseCase extends UseCase<SignInRequest, bool> {
  final FirebaseAuthProvider firebaseAuthProvider;
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  SignInEmailAndPasswordUseCase(
    Ref ref,
    this.firebaseAuthProvider,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    SignInRequest request,
  ) async {
    try {
      final email = request.email;
      final password = request.password;

      final userCredential =
          await firebaseAuthProvider.singInEmailAndPassword(email, password);

      final uid = userCredential.user?.uid;

      if (uid != null) {
        final collect = fireCloudStore.collection('user');

        await collect.doc(uid).update(
          {
            "isOnline": true,
          },
        );

        await baseSharedPreference.setString(
          BaseSharePreferenceKey.userId,
          uid,
        );

        return true;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
