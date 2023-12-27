import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/cart/model/request/cart_request.dart';

final updateToCartUsecaseProvider = Provider<UpdateToCartUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return UpdateToCartUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class UpdateToCartUsecase extends UseCase<CartRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  UpdateToCartUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    CartRequest request,
  ) async {
    try {
      final cartId = request.id;
      final vatFee = request.vatFee;
      final status = request.status;
      final deliveryFee = request.deliveryFee;
      final totalPrice = request.totalPrice;
      final summaryPrice = request.summaryPrice;
      final fullName = request.fullName;
      final phone = request.phone;
      final address = request.address;
      final district = request.district;
      final subDistrict = request.subDistrict;
      final province = request.province;
      final postNumber = request.postNumber;
      final collectCart = fireCloudStore.collection('cart');

      final Map<String, dynamic> myData = {
        "vatFee": vatFee,
        "deliveryFee": deliveryFee,
        "totalPrice": totalPrice,
        "summaryPrice": summaryPrice,
        "status": status?.name,
        "fullName": fullName,
        "phone": phone,
        "address": address,
        "district": district,
        "subDistrict": subDistrict,
        "province": province,
        "postNumber": postNumber,
        "update_at": DateTime.now(),
      };

      await collectCart.doc(cartId).update(myData);

      return true;
    } catch (e) {
      return false;
    }
  }
}
