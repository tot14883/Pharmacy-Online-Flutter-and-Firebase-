import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/chat_with_pharmacy_request.dart';

final approveChatWithPharmacyUsecaseProvider =
    Provider<ApproveChatWithPharmacyUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return ApproveChatWithPharmacyUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class ApproveChatWithPharmacyUsecase
    extends UseCase<ChatWithPharmacyRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  ApproveChatWithPharmacyUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharePreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    ChatWithPharmacyRequest request,
  ) async {
    try {
      final id = request.id ?? '';
      final isApprove = request.isApprove ?? false;

      final collect = fireCloudStore.collection('chat');

      final Map<String, dynamic> myData = {
        "status": isApprove ? "approve" : "cancel",
        "update_at": DateTime.now(),
      };

      await collect.doc(id).update(myData);

      return true;
    } catch (e) {
      return false;
    }
  }
}
