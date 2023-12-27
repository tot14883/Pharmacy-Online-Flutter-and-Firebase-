import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/comment_request.dart';

final checkReviewAlreadyUsecaseProvider =
    Provider<CheckReviewAlreadyUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return CheckReviewAlreadyUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class CheckReviewAlreadyUsecase extends UseCase<CommentRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  CheckReviewAlreadyUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    CommentRequest request,
  ) async {
    try {
      final orderId = request.orderId;

      final collectReview = await fireCloudStore
          .collection('review')
          .where('orderId', isEqualTo: orderId)
          .get()
          .then((value) => value.docs);

      return collectReview.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
