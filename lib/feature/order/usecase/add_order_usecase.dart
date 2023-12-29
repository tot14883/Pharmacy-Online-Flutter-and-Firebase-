import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/order/model/request/order_request.dart';

final addOrderUsecaseProvider = Provider<AddOrderUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return AddOrderUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class AddOrderUsecase extends UseCase<OrderRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  AddOrderUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    OrderRequest request,
  ) async {
    try {
      final storeId = request.storeId;
      final uid = baseSharedPreference.getString(BaseSharePreferenceKey.userId);
      final pharmacyId = request.pharmacyId;
      final cartId = request.cartId;

      final collectOrder = fireCloudStore.collection('order');
      final orderId = collectOrder.doc().id;

      final random = Random();
      int randomNumber = random.nextInt(10000);

      final Map<String, dynamic> myData = {
        "id": orderId,
        "storeId": storeId,
        "orderNumber": "ORDER$randomNumber",
        "pharmacyId": pharmacyId,
        "uid": uid,
        "cartId": cartId,
        "status": OrderStatus.confirmOrder.name,
        "create_at": DateTime.now(),
        "update_at": DateTime.now(),
      };

      await collectOrder.doc(orderId).set(myData);

      return true;
    } catch (e) {
      return false;
    }
  }
}
