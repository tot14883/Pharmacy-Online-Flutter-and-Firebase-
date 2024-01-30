import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/order/model/request/review_request.dart';

final editReviewStoreUsecaseProvider = Provider<EditReviewStoreUsecase>((ref) {
  //`editReviewStoreUsecaseProvider` คือ Provider ที่ให้บริการ `EditReviewStoreUsecase` ซึ่งเป็น `UseCase` ที่ทำหน้าที่แก้ไขข้อมูลรีวิว
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
      //ดึงข้อมูลที่ต้องการแก้ไขจาก `request`
      final reviewId = request.reviewId;
      final message = request.message;
      final rating = request.rating;

      //สร้าง `collectReview` ซึ่งเป็นคอลเลคชันของ Firebase Cloud Firestore ที่เกี่ยวข้องกับข้อมูลรีวิว
      final collectReview = fireCloudStore.collection('review');

      //สร้าง Map ที่ประกอบด้วยข้อมูลที่ต้องการแก้ไข เช่น `rating`, `message`, และ `update_at`
      Map<String, dynamic> myData = {
        "rating": rating,
        "message": message,
        "update_at": DateTime.now(),
      };
      //ทำการอัปเดตข้อมูลรีวิวด้วย `collectReview.doc(reviewId).update(myData)`
      await collectReview.doc(reviewId).update(myData);

      return true;
    } catch (e) {
      return false;
    }
  }
}
