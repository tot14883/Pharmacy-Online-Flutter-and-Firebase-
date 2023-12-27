import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/order/model/request/review_request.dart';

final addReviewStoreUsecaseProvider = Provider<AddReviewStoreUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return AddReviewStoreUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class AddReviewStoreUsecase extends UseCase<ReviewRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  AddReviewStoreUsecase(
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
      final orderId = request.orderId;
      final pharmacyId = request.pharmacyId;
      final uid = request.uid;
      final message = request.message;
      final rating = request.rating;

      final collectReview = fireCloudStore.collection('review');
      final reviewId = collectReview.doc().id;

      Map<String, dynamic> myData = {
        "id": reviewId,
        "orderId": orderId,
        "rating": rating,
        "pharmacyId": pharmacyId,
        "uid": uid,
        "message": message,
        "create_at": DateTime.now(),
        "update_at": DateTime.now(),
      };

      await collectReview.doc(reviewId).set(myData);

      return true;
    } catch (e) {
      return false;
    }
  }
}
