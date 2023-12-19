import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/authentication/model/request/user_info_request.dart';

final updatePharmacyStoreUsecaseProvider =
    Provider<UpdatePharmacyStoreUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return UpdatePharmacyStoreUsecase(
    ref,
    fireCloudStore,
    firebaseCloudStorage,
    baseSharedPreference,
  );
});

class UpdatePharmacyStoreUsecase extends UseCase<UserInfoRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final FirebaseStorageProvider firebaseCloudStorage;
  final BaseSharedPreference baseSharedPreference;

  UpdatePharmacyStoreUsecase(
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
      final address = request.address;
      final licensePharmacy = request.licensePharmacy ?? '';
      final licensePharmacyImg = request.licensePharmacyImg;
      final nameStore = request.nameStore ?? '';
      final currentLicensePharmacyImg = request.currentLicensePharmacyImg;
      final currentStoreImg = request.currentStoreImg ?? '';
      final phoneStore = request.phoneStore ?? '';
      final latitude = request.latitude ?? 0.0;
      final longtitude = request.longtitude ?? 0.0;
      final timeOpening = request.timeOpening ?? '';
      final timeClosing = request.timeClosing ?? '';
      final licenseStore = request.licenseStore ?? '';
      final licenseStoreImg = request.licenseStoreImg;
      final currentLicenseStoreImg = request.currentLicenseStoreImg;
      final storeImg = request.storeImg;
      final qrCodeImg = request.qrCodeImg;
      final currentQrCodeImg = request.currentQrCodeImg;

      final uid = baseSharedPreference.getString(BaseSharePreferenceKey.userId);

      if (uid != null) {
        String urlLicensePharmacyImg = '';
        String urlLicenseStoreImg = '';
        String urlQrCodeImg = '';
        String urlStoreImg = '';

        if (licensePharmacyImg != null) {
          urlLicensePharmacyImg = await firebaseCloudStorage.uploadStorage(
            licensePharmacyImg,
            'pharmacy/$uid',
          );
        }

        if (licenseStoreImg != null && storeImg != null) {
          urlStoreImg = await firebaseCloudStorage.uploadStorage(
            storeImg,
            'pharmacyStore/$uid',
          );
          urlLicenseStoreImg = await firebaseCloudStorage.uploadStorage(
            licenseStoreImg,
            'pharmacyStore/$uid',
          );
        }

        if (qrCodeImg != null) {
          urlQrCodeImg = await firebaseCloudStorage.uploadStorage(
            qrCodeImg,
            'qrCode/$uid',
          );
        }

        final collectPharmacyStore = fireCloudStore.collection('pharmacyStore');

        final Map<String, dynamic> myData = {
          "uid": uid,
          "nameStore": nameStore,
          "address": address,
          "licensePharmacy": licensePharmacy,
          "licensePharmacyImg": licensePharmacyImg != null
              ? urlLicensePharmacyImg
              : currentLicensePharmacyImg,
          "phoneStore": phoneStore,
          "latitude": latitude,
          "longtitude": longtitude,
          "status": "waiting",
          "timeOpening": timeOpening,
          "timeClosing": timeClosing,
          "licenseStore": licenseStore,
          "licenseStoreImg": licenseStoreImg != null
              ? urlLicenseStoreImg
              : currentLicenseStoreImg,
          "qrCodeImg": qrCodeImg != null ? urlQrCodeImg : currentQrCodeImg,
          "storeImg": storeImg != null ? urlStoreImg : currentStoreImg,
          "update_at": DateTime.now(),
        };

        await collectPharmacyStore.doc(uid).update(
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
