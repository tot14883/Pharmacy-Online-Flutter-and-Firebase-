import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/store/model/request/chat_with_pharmacy_request.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';

final getChatDetailUsecaseProvider = Provider<GetChatDetailUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharePreference = ref.watch(baseSharePreferenceProvider);
  return GetChatDetailUsecase(
    ref,
    fireCloudStore,
    baseSharePreference,
  );
});

class GetChatDetailUsecase
    extends UseCase<ChatWithPharmacyRequest, ChatWithPharmacyResponse> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharePreference;

  GetChatDetailUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharePreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<ChatWithPharmacyResponse> exec(
    ChatWithPharmacyRequest request,
  ) async {
    try {
      final role = baseSharePreference.getString(BaseSharePreferenceKey.role);
      final pharmacyId = request.pharmacyId ?? '';

      final uid = request.uid ?? '';

      final collectChat = await fireCloudStore
          .collection('chat')
          .where('uid', isEqualTo: uid)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .where(
            'status',
            isEqualTo: "approve",
          )
          .get()
          .then((value) => value.docs);

      for (final item in collectChat) {
        final _data = item.data() as Map<String, dynamic>;

        DocumentSnapshot<Object?>? collectUser;
        DocumentSnapshot<Object?>? collectPharmacyStore;

        if (role == AuthenticationType.pharmacy.name) {
          collectUser = await fireCloudStore
              .collection('user')
              .doc(_data['uid'])
              .get()
              .then((value) => value);
        } else {
          collectUser = await fireCloudStore
              .collection('user')
              .doc(_data['pharmacyId'])
              .get()
              .then((value) => value);
          collectPharmacyStore = await fireCloudStore
              .collection('pharmacyStore')
              .doc(_data['pharmacyId'])
              .get()
              .then((value) => value);
        }

        return ChatWithPharmacyResponse(
          id: _data['id'],
          uid: _data['uid'],
          pharmacyId: _data['pharmacyId'],
          profileImg: collectUser?['profileImg'],
          nameStore: collectPharmacyStore?['nameStore'],
          fullName: collectUser?['fullName'],
          chatImg: _data['chatImg'],
          message: _data['message'],
          createAt: (_data['create_at'] as Timestamp).toDate(),
          updateAt: (_data['update_at'] as Timestamp).toDate(),
        );
      }

      return const ChatWithPharmacyResponse();
    } catch (e) {
      return const ChatWithPharmacyResponse();
    }
  }
}
