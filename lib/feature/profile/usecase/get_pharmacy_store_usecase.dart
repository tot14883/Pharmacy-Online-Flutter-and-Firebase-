import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/authentication/model/response/pharmacy_store_response.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';

final getPharmacyUsecaseProvider = Provider<GetPharmacyUseCase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);
  final baseUtils = ref.watch(baseUtilsProvider);

  return GetPharmacyUseCase(
    ref,
    fireCloudStore,
    baseSharedPreference,
    baseUtils,
  );
});

class GetPharmacyUseCase extends UseCase<void, PharmacyStoreResponse> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;
  final BaseUtils baseUtils;

  GetPharmacyUseCase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
    this.baseUtils,
  ) {
    this.ref = ref;
  }

  @override
  Future<PharmacyStoreResponse> exec(
    void request,
  ) async {
    try {
      final uid = baseSharedPreference.getString(BaseSharePreferenceKey.userId);

      if (uid != null) {
        final collect = fireCloudStore.collection('pharmacyStore');

        final data = await collect
            .doc(
              uid,
            )
            .get()
            .then((value) => value.data() as Map<String, dynamic>);

        return PharmacyStoreResponse(
          uid: data['uid'],
          address: data['address'],
          latitude: data['latitude'],
          longtitude: data['longtitude'],
          status: data['status'],
          licensePharmacy: data['licensePharmacy'],
          licensePharmacyImg: data['licensePharmacyImg'],
          nameStore: data['nameStore'],
          phoneStore: data['phoneStore'],
          timeOpening: data['timeOpening'],
          timeClosing: data['timeClosing'],
          licenseStore: data['licenseStore'],
          licenseStoreImg: data['licenseStoreImg'],
          qrCodeImg: data['qrCodeImg'],
          storeImg: data['storeImg'],
          create_at: (data['create_at'] as Timestamp).toDate(),
        );
      }

      return const PharmacyStoreResponse();
    } catch (e) {
      return const PharmacyStoreResponse();
    }
  }
}
