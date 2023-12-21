import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/feature/store/model/request/medicine_request.dart';

final deleteMedicineWarehouseUsecaseProvider =
    Provider<DeleteMedicineWarehouseUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  return DeleteMedicineWarehouseUsecase(
    ref,
    fireCloudStore,
  );
});

class DeleteMedicineWarehouseUsecase extends UseCase<MedicineRequest, bool> {
  final FirebaseCloudStore fireCloudStore;

  DeleteMedicineWarehouseUsecase(
    Ref ref,
    this.fireCloudStore,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    MedicineRequest request,
  ) async {
    try {
      final id = request.id ?? '';

      final collectUser = fireCloudStore.collection('medicineWarehouse');

      await collectUser.doc(id).delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
