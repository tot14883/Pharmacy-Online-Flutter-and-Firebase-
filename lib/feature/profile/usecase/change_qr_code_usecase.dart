import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';

final changeQRCodeUsecaseProvider = Provider<ChangeQRCodeUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return ChangeQRCodeUsecase(
    ref,
    fireCloudStore,
    firebaseCloudStorage,
    baseSharedPreference,
  );
});

class ChangeQRCodeUsecase extends UseCase<XFile, bool> {
  final FirebaseCloudStore fireCloudStore;
  final FirebaseStorageProvider firebaseCloudStorage;
  final BaseSharedPreference baseSharedPreference;

  ChangeQRCodeUsecase(
    Ref ref,
    this.fireCloudStore,
    this.firebaseCloudStorage,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    XFile request,
  ) async {
    try {
      final uid = baseSharedPreference.getString(BaseSharePreferenceKey.userId);

      if (uid != null) {
        final urlQrCodeImg = await firebaseCloudStorage.uploadStorage(
          request,
          'qrCode/$uid',
        );

        final collectPharmacyStore = fireCloudStore.collection('pharmacyStore');

        final Map<String, dynamic> myData = {
          "qrCodeImg": urlQrCodeImg,
          "update_at": DateTime.now(),
        };

        await collectPharmacyStore.doc(uid).update(myData);

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
