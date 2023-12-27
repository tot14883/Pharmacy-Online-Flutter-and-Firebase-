import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/home/model/request/notification_request.dart';

final postNotificationUsecaseProvider =
    Provider<PostNotificationUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return PostNotificationUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class PostNotificationUsecase extends UseCase<NotificationRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  PostNotificationUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharePreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    NotificationRequest request,
  ) async {
    try {
      final uid = request.uid;
      final message = request.message;
      final status = request.status;

      final collect = fireCloudStore.collection('notification');
      final collectId = collect.doc().id;

      final Map<String, dynamic> myData = {
        "id": collectId,
        "uid": uid,
        "message": message,
        "status": status,
        "isRead": false,
        "create_at": DateTime.now(),
      };

      await collect.doc(collectId).set(myData);

      return true;
    } catch (e) {
      return true;
    }
  }
}
