import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/order/model/request/order_request.dart';

final updatDeliverySlipUsecaseProvider =
    Provider<UpdatDeliverySlipUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);

  return UpdatDeliverySlipUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
    firebaseCloudStorage,
  );
});

class UpdatDeliverySlipUsecase extends UseCase<OrderRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;
  final FirebaseStorageProvider firebaseCloudStorage;

  UpdatDeliverySlipUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
    this.firebaseCloudStorage,
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
      final deliverySlip = request.deliverySlip;

      final collectOrder = fireCloudStore.collection('order');

      String urlDeliverySlip = '';

      if (deliverySlip != null) {
        urlDeliverySlip = await firebaseCloudStorage.uploadStorage(
          deliverySlip,
          'order/$id',
        );
      }

      final Map<String, dynamic> myData = {
        "deliverySlip": urlDeliverySlip,
        "status": OrderStatus.waitingDelivery.name,
        "update_at": DateTime.now(),
      };

      await collectOrder.doc(id).update(myData);

      if (cartId != null) {
        await fireCloudStore.collection('cart').doc(cartId).update(
          {
            "status": OrderStatus.waitingDelivery.name,
            'update_at': DateTime.now(),
          },
        );
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
