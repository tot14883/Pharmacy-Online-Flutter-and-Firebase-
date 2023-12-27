import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/comment_request.dart';

final deleteReviewStoreUsecaseProvider =
    Provider<DeleteReviewStoreUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return DeleteReviewStoreUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class DeleteReviewStoreUsecase extends UseCase<CommentRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  DeleteReviewStoreUsecase(
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
      final reviewId = request.reviewId;

      final collectReview = fireCloudStore.collection('review');

      final collectComment = await collectReview
          .doc(reviewId)
          .collection('comment')
          .get()
          .then((value) => value.docs);

      for (final item in collectComment) {
        final _data = item.data();
        await collectReview
            .doc(reviewId)
            .collection('comment')
            .doc(_data['commentId'])
            .delete();
      }

      await collectReview.doc(reviewId).delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
