import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/order/model/request/order_request.dart';

final updatBankTransferUsecaseProvider =
    Provider<UpdatBankTransferUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);
  final firebaseCloudStorage = ref.watch(firebaseCloudStorageProvider);

  return UpdatBankTransferUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
    firebaseCloudStorage,
  );
});

class UpdatBankTransferUsecase extends UseCase<OrderRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;
  final FirebaseStorageProvider firebaseCloudStorage;

  UpdatBankTransferUsecase(
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
      final bankTransferSlip = request.bankTransferSlip;
      final bankTransferDate = request.bankTransferDate;
      final bankTotalPriceSlip = request.bankTotalPriceSlip;

      final collectOrder = fireCloudStore.collection('order');

      String urlBankTransferSlip = '';

      if (bankTransferSlip != null) {
        urlBankTransferSlip = await firebaseCloudStorage.uploadStorage(
          bankTransferSlip,
          'order/$id',
        );
      }

      final Map<String, dynamic> myData = {
        "bankTransferDate": bankTransferDate,
        "urlBankTransferSlip": urlBankTransferSlip,
        "bankTotalPriceSlip": bankTotalPriceSlip,
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
