import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/order/model/request/review_request.dart';
import 'package:pharmacy_online/feature/store/model/response/reviews_response.dart';

final getReviewStoreUsecaseProvider = Provider<GetReviewStoreUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return GetReviewStoreUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class GetReviewStoreUsecase
    extends UseCase<ReviewRequest, List<ReviewsResponse>> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  GetReviewStoreUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<List<ReviewsResponse>> exec(
    ReviewRequest request,
  ) async {
    try {
      final pharmacyId = request.pharmacyId;

      final collectReview = await fireCloudStore
          .collection('review')
          .where('pharmacyId', isEqualTo: pharmacyId)
          .orderBy('create_at')
          .get()
          .then((value) => value.docs);

      List<ReviewsResponse> reviewList = [];

      for (final item in collectReview.reversed) {
        final _data = item.data() as Map<String, dynamic>;

        final collectUser = await fireCloudStore
            .collection('user')
            .doc(_data['uid'])
            .get()
            .then((value) => value);

        final _user = collectUser.data() as Map<String, dynamic>;

        reviewList.add(
          ReviewsResponse(
            id: _data['id'],
            pharmacyId: _data['pharmacyId'],
            uid: _data['uid'],
            fullName: _user['fullName'],
            profileImg: _user['profileImg'],
            rating: _data['rating'],
            message: _data['message'],
            createAt: (_data['create_at'] as Timestamp).toDate(),
          ),
        );
      }

      return reviewList;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
