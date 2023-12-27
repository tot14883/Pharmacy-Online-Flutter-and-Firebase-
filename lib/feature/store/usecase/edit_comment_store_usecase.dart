import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/request/comment_request.dart';

final editCommentStoreUsecaseProvider =
    Provider<EditCommentStoreUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return EditCommentStoreUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class EditCommentStoreUsecase extends UseCase<CommentRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  EditCommentStoreUsecase(
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
      final commentId = request.commentId;
      final reviewId = request.reviewId;
      final message = request.message;

      final collectReview = fireCloudStore
          .collection('review')
          .doc(reviewId)
          .collection('comment');

      Map<String, dynamic> myData = {
        "message": message,
        "update_at": DateTime.now(),
      };

      await collectReview.doc(commentId).update(myData);

      return true;
    } catch (e) {
      return false;
    }
  }
}
