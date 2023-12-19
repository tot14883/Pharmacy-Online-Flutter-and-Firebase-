import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/authentication/model/response/user_info_response.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';

final getUserInfoUsecaseProvider = Provider<GetUserInfoUseCase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);
  final baseUtils = ref.watch(baseUtilsProvider);

  return GetUserInfoUseCase(
    ref,
    fireCloudStore,
    baseSharedPreference,
    baseUtils,
  );
});

class GetUserInfoUseCase extends UseCase<void, UserInfoResponse> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;
  final BaseUtils baseUtils;

  GetUserInfoUseCase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
    this.baseUtils,
  ) {
    this.ref = ref;
  }

  @override
  Future<UserInfoResponse> exec(
    void request,
  ) async {
    try {
      final uid = baseSharedPreference.getString(BaseSharePreferenceKey.userId);

      if (uid != null) {
        final collect = fireCloudStore.collection('user');

        final data = await collect
            .doc(
              uid,
            )
            .get()
            .then((value) => value.data() as Map<String, dynamic>);

        await collect.doc(uid).update(
          {
            "isOnline": true,
          },
        );

        return UserInfoResponse(
          uid: data['uid'],
          email: data['email'],
          password: data['password'],
          role: data['role'],
          profileImg: data['profileImg'],
          fullName: data['fullName'],
          address: data['address'],
          phone: data['phone'],
          latitude: data['latitude'],
          longtitude: data['longtitude'],
          status: data['status'],
          create_at: (data['create_at'] as Timestamp).toDate(),
        );
      }

      return const UserInfoResponse();
    } catch (e) {
      print(e);
      return const UserInfoResponse();
    }
  }
}
