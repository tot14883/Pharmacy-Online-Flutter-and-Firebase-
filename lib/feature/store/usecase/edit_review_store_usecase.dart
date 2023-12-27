import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/order/model/request/review_request.dart';

final editReviewStoreUsecaseProvider = Provider<EditReviewStoreUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return EditReviewStoreUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class EditReviewStoreUsecase extends UseCase<ReviewRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  EditReviewStoreUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    ReviewRequest request,
  ) async {
    try {
      final reviewId = request.reviewId;
      final message = request.message;
      final rating = request.rating;

      final collectReview = fireCloudStore.collection('review');

      Map<String, dynamic> myData = {
        "rating": rating,
        "message": message,
        "update_at": DateTime.now(),
      };

      await collectReview.doc(reviewId).update(myData);

      return true;
    } catch (e) {
      return false;
    }
  }
}
