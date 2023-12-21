import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/medicine_request.dart';

final addCentralMedicineToMyWarehouseUsecaseProvider =
    Provider<AddCentralMedicineToMyWarehouseUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return AddCentralMedicineToMyWarehouseUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class AddCentralMedicineToMyWarehouseUsecase
    extends UseCase<MedicineRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  AddCentralMedicineToMyWarehouseUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharePreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    MedicineRequest request,
  ) async {
    try {
      final name = request.name ?? '';
      final price = request.price ?? 0.0;
      final medicineImg = request.currentMedicineImg;

      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);

      final collect = fireCloudStore.collection('medicineWarehouse');
      final collectId = collect.doc().id;

      final Map<String, dynamic> myData = {
        "id": collectId,
        "uid": uid,
        "name": name,
        "price": price,
        "medicineImg": medicineImg,
        "isCentral": false,
        "create_at": DateTime.now(),
        "update_at": DateTime.now(),
      };

      await collect.doc(collectId).set(myData);

      return true;
    } catch (e) {
      return false;
    }
  }
}
