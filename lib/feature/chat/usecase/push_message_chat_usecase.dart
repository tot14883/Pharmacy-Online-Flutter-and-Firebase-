import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/chat_with_pharmacy_request.dart';

final pushMessageChatUsecaseProvider = Provider<PushMessageChatUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);

  return PushMessageChatUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
    firebaseCloudStorage,
  );
});

class PushMessageChatUsecase extends UseCase<ChatWithPharmacyRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;
  final FirebaseStorageProvider firebaseCloudStorage;

  PushMessageChatUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharePreference,
    this.firebaseCloudStorage,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    ChatWithPharmacyRequest request,
  ) async {
    try {
      final id = request.id ?? '';
      final message = request.message ?? '';
      final chatImg = request.chatImg;
      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);

      final collectChat = fireCloudStore.collection('chat');

      final collect =
          fireCloudStore.collection('chat').doc(id).collection('chat_message');
      final messageId = collect.doc().id;

      String urlChatImg = '';

      if (chatImg != null) {
        urlChatImg = await firebaseCloudStorage.uploadStorage(
          chatImg,
          'chat/$id',
        );
      }

      await collectChat.doc(id).update({'update_at': DateTime.now()});

      final Map<String, dynamic> myData = {
        "id": messageId,
        "chatId": id,
        "uid": uid,
        "message": message,
        "chatImg": urlChatImg,
        "create_at": DateTime.now(),
        "update_at": DateTime.now(),
      };

      await collect.doc(messageId).set(myData);

      return true;
    } catch (e) {
      return false;
    }
  }
}
