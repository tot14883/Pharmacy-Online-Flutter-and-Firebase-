import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/medicine_request.dart';

final editMedicineWarehouseUsecaseProvider =
    Provider<EditMedicineWarehouseUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return EditMedicineWarehouseUsecase(
    ref,
    fireCloudStore,
    firebaseCloudStorage,
    baseSharePreference,
  );
});

class EditMedicineWarehouseUsecase extends UseCase<MedicineRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final FirebaseStorageProvider firebaseCloudStorage;
  final BaseSharedPreference baseSharePreference;

  EditMedicineWarehouseUsecase(
    Ref ref,
    this.fireCloudStore,
    this.firebaseCloudStorage,
    this.baseSharePreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    MedicineRequest request,
  ) async {
    try {
      final id = request.id ?? '';
      final name = request.name ?? '';
      final price = request.price ?? 0.0;
      final medicineImg = request.medicineImg;
      final currentMedicineImg = request.currentMedicineImg;

      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);

      if (uid != null) {
        String urlMedicineImg = '';

        if (medicineImg != null) {
          urlMedicineImg = await firebaseCloudStorage.uploadStorage(
            medicineImg,
            'medicineWarehouse/$uid',
          );
        }

        final collectUser = fireCloudStore.collection('medicineWarehouse');

        final Map<String, dynamic> myData = {
          "name": name,
          "price": price,
          "medicineImg":
              medicineImg != null ? urlMedicineImg : currentMedicineImg,
          "update_at": DateTime.now(),
        };

        await collectUser.doc(id).update(myData);

        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
