import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/order/model/request/order_request.dart';

final updateOrderUsecaseProvider = Provider<UpdateOrderUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return UpdateOrderUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class UpdateOrderUsecase extends UseCase<OrderRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  UpdateOrderUsecase(
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
      final diagnose = request.diagnose;
      final moreDetail = request.moreDetail;
      final howToUse = request.howToUse;
      final status = request.status;

      final collectOrder = fireCloudStore.collection('order');

      if (diagnose != null) {
        final Map<String, dynamic> myData = {
          "diagnose": diagnose,
          "moreDetail": moreDetail,
          "update_at": DateTime.now(),
        };

        await collectOrder.doc(id).update(myData);
      }

      if (cartId != null && howToUse != null) {
        for (final howToUseItem in howToUse) {
          final _medicineData = howToUseItem;

          await fireCloudStore
              .collection('cart')
              .doc(cartId)
              .collection("medicine")
              .doc(_medicineData.entries.first.key)
              .update({'howToUse': _medicineData.entries.first.value});
        }

        await fireCloudStore.collection('cart').doc(cartId).update(
          {
            'status': status?.name,
            'update_at': DateTime.now(),
          },
        );
      }

      if (status != null) {
        await collectOrder.doc(id).update({'status': status.name});
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
