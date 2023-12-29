import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/chat_with_pharmacy_request.dart';

final checkRequestChatWaitingUsecaseProvider =
    Provider<CheckRequestChatWaitingUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return CheckRequestChatWaitingUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class CheckRequestChatWaitingUsecase
    extends UseCase<ChatWithPharmacyRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  CheckRequestChatWaitingUsecase(
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
      final pharmacyId = request.pharmacyId ?? '';

      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);

      final hasRequest = await fireCloudStore
          .collection('chat')
          .where('uid', isEqualTo: uid)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .where(
            'status',
            isEqualTo: "waiting",
          )
          .get()
          .then((value) => value.docs);

      return hasRequest.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
