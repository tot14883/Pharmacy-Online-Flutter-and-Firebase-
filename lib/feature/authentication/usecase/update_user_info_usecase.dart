import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/authentication/model/request/user_info_request.dart';

final updateUserInfoUsecaseProvider = Provider<UpdateUserInfoUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);
  return UpdateUserInfoUsecase(
    ref,
    fireCloudStore,
    firebaseCloudStorage,
    baseSharedPreference,
  );
});

class UpdateUserInfoUsecase extends UseCase<UserInfoRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final FirebaseStorageProvider firebaseCloudStorage;
  final BaseSharedPreference baseSharedPreference;

  UpdateUserInfoUsecase(
    Ref ref,
    this.fireCloudStore,
    this.firebaseCloudStorage,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    UserInfoRequest request,
  ) async {
    try {
      final email = request.email ?? '';
      final password = request.password ?? '';
      final profileImg = request.profileImg;
      final currentProfileImg = request.currentProfileImg;
      final fullName = request.fullName ?? '';
      final address = request.address;
      final phone = request.phone ?? '';
      final latitude = request.latitude ?? 0.0;
      final longtitude = request.longtitude ?? 0.0;

      final uid = baseSharedPreference.getString(BaseSharePreferenceKey.userId);

      if (uid != null) {
        String urlProfileImage = '';

        if (profileImg != null) {
          urlProfileImage = await firebaseCloudStorage.uploadStorage(
            profileImg,
            'user/$uid',
          );
        }

        final collectUser = fireCloudStore.collection('user');

        final Map<String, dynamic> myData = {
          "profileImg":
              profileImg != null ? urlProfileImage : currentProfileImg,
          "email": email,
          "password": password,
          "fullName": fullName,
          "address": address,
          "phone": phone,
          "latitude": latitude,
          "longtitude": longtitude,
          "uid": uid,
          "status": "waiting",
          "isOnline": false,
          "update_at": DateTime.now(),
        };

        await collectUser.doc(uid).set(
              myData,
            );

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
