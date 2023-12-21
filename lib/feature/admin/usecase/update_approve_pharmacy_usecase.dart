import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/feature/admin/model/request/approve_request.dart';

final updateApprovePharmacyUsecaseProvider =
    Provider<UpdateApprovePharmacyUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);

  return UpdateApprovePharmacyUsecase(
    ref,
    fireCloudStore,
  );
});

class UpdateApprovePharmacyUsecase extends UseCase<ApproveRequest, bool> {
  final FirebaseCloudStore fireCloudStore;

  UpdateApprovePharmacyUsecase(
    Ref ref,
    this.fireCloudStore,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    ApproveRequest request,
  ) async {
    try {
      final collectUser = fireCloudStore.collection('user');
      final collectPharmacyStore = fireCloudStore.collection('pharmacyStore');

      await collectUser
          .doc(request.uid)
          .update({'status': request.isApprove ? 'approve' : 'cancel'});
      await collectPharmacyStore
          .doc(request.uid)
          .update({'status': request.isApprove ? 'approve' : 'cancel'});
      return true;
    } catch (e) {
      return false;
    }
  }
}
