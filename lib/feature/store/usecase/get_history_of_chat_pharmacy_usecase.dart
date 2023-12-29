import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';

final getHistoryOfChatPharmacyUsecaseProvider =
    Provider<GetHistoryOfChatPharmacyUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return GetHistoryOfChatPharmacyUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class GetHistoryOfChatPharmacyUsecase
    extends UseCase<void, List<ChatWithPharmacyResponse>> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  GetHistoryOfChatPharmacyUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharePreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<List<ChatWithPharmacyResponse>> exec(
    void request,
  ) async {
    try {
      final uid = baseSharePreference.getString(BaseSharePreferenceKey.userId);

      final collect = await fireCloudStore
          .collection('chat')
          .where('status', isEqualTo: 'approve')
          .where(
            'pharmacyId',
            isEqualTo: uid,
          )
          .orderBy('create_at')
          .get()
          .then((value) => value.docs);

      List<ChatWithPharmacyResponse> requestChatList = [];

      for (final item in collect.reversed) {
        final _data = item.data() as Map<String, dynamic>;

        final collectUser = await fireCloudStore
            .collection('user')
            .where(
              'uid',
              isEqualTo: _data['uid'],
            )
            .get()
            .then((value) => value.docs);

        final _user = collectUser.first.data() as Map<String, dynamic>;

        print(_user);

        final collectMessage = await fireCloudStore
            .collection('chat')
            .doc(_data['id'])
            .collection('chat_message')
            .orderBy('create_at')
            .get()
            .then((value) => value.docs);

        Map<String, dynamic>? _message;
        if (collectMessage.isNotEmpty) {
          _message = collectMessage.last.data();
        }

        requestChatList.add(
          ChatWithPharmacyResponse(
            id: _data['id'],
            uid: _data['uid'],
            pharmacyId: _data['pharmacyId'],
            profileImg: _user['profileImg'],
            fullName: _user['fullName'],
            chatImg: "ไฟล์รูปภาพ",
            message: _message?['message'] ?? '',
            isOnline: _user['isOnline'],
            createAt: (_data['create_at'] as Timestamp).toDate(),
            updateAt: (_data['update_at'] as Timestamp).toDate(),
          ),
        );
      }

      return requestChatList;
    } catch (e) {
      return [];
    }
  }
}
