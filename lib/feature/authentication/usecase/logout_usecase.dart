import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/auth/auth_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';

final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return LogoutUsecase(
    ref,
    firebaseAuth,
    fireCloudStore,
    baseSharedPreference,
  );
});

class LogoutUsecase extends UseCase<void, bool> {
  final FirebaseAuthProvider firebaseAuthProvider;
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  LogoutUsecase(
    Ref ref,
    this.firebaseAuthProvider,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    void request,
  ) async {
    try {
      final uid = baseSharedPreference.getString(BaseSharePreferenceKey.userId);

      if (uid != null) {
        await firebaseAuthProvider.signOut();
        final collect = fireCloudStore.collection('user');

        await collect.doc(uid).update(
          {
            "isOnline": false,
          },
        );

        await baseSharedPreference.remove(
          BaseSharePreferenceKey.userId,
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
