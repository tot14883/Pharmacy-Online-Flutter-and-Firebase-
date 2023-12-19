import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/auth/auth_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/authentication/model/request/user_info_request.dart';

final createUserInfoUsecaseProvider = Provider<CreateUserInfoUsecase>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);
  return CreateUserInfoUsecase(
    ref,
    firebaseAuth,
    fireCloudStore,
    firebaseCloudStorage,
  );
});

class CreateUserInfoUsecase extends UseCase<UserInfoRequest, bool> {
  final FirebaseAuthProvider firebaseAuthProvider;
  final FirebaseCloudStore fireCloudStore;
  final FirebaseStorageProvider firebaseCloudStorage;

  CreateUserInfoUsecase(
    Ref ref,
    this.firebaseAuthProvider,
    this.fireCloudStore,
    this.firebaseCloudStorage,
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
      final role = request.role ?? '';
      final profileImg = request.profileImg;
      final fullName = request.fullName ?? '';
      final address = request.address;
      final licensePharmacy = request.licensePharmacy ?? '';
      final licensePharmacyImg = request.licensePharmacyImg;
      final nameStore = request.nameStore ?? '';
      final phone = request.phone ?? '';
      final phoneStore = request.phoneStore ?? '';
      final latitude = request.latitude ?? 0.0;
      final longtitude = request.longtitude ?? 0.0;
      final timeOpening = request.timeOpening ?? '';
      final timeClosing = request.timeClosing ?? '';
      final licenseStore = request.licenseStore ?? '';
      final licenseStoreImg = request.licenseStoreImg;
      final storeImg = request.storeImg;
      final qrCodeImg = request.qrCodeImg;

      final userCredential =
          await firebaseAuthProvider.createEmailAndPassword(email, password);
      final uid = userCredential.user?.uid;

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
          "profileImg": urlProfileImage,
          "email": email,
          "password": password,
          "role": role,
          "fullName": fullName,
          "address": address,
          "phone": phone,
          "latitude": latitude,
          "longtitude": longtitude,
          "uid": uid,
          "status": "waiting",
          "isOnline": false,
          "create_at": DateTime.now(),
          "update_at": DateTime.now(),
        };

        await collectUser.doc('$uid').set(myData);

        if (role == AuthenticationType.pharmacy.name) {
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

          final collectPharmacyStore =
              fireCloudStore.collection('pharmacyStore');

          final Map<String, dynamic> myData = {
            "uid": uid,
            "nameStore": nameStore,
            "address": address,
            "licensePharmacy": licensePharmacy,
            "licensePharmacyImg": urlLicensePharmacyImg,
            "phoneStore": phoneStore,
            "latitude": latitude,
            "longtitude": longtitude,
            "status": "waiting",
            "timeOpening": timeOpening,
            "timeClosing": timeClosing,
            "licenseStore": licenseStore,
            "licenseStoreImg": urlLicenseStoreImg,
            "qrCodeImg": urlQrCodeImg,
            "storeImg": urlStoreImg,
            "create_at": DateTime.now(),
            "update_at": DateTime.now(),
          };

          await collectPharmacyStore.doc('$uid').set(myData);
        }

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
