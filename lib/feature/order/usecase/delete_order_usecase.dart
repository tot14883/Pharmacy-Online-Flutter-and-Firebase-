import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/order/model/request/order_request.dart';

final deleteOrderUsecaseProvider = Provider<DeleteOrderUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return DeleteOrderUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class DeleteOrderUsecase extends UseCase<OrderRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  DeleteOrderUsecase(
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
      final id = request.id;
      final cartId = request.cartId;

      final collectOrder = fireCloudStore.collection('order');

      await collectOrder.doc(id).delete();

      final collectMedicine = fireCloudStore.collection('cart');

      await collectMedicine.doc(cartId).delete();

      return true;
    } catch (e) {
      return false;
    }
  }
}
