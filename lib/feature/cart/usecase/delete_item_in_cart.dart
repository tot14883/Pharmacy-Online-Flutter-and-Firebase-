import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/cart/model/request/cart_request.dart';

final deleteItemInCartUsecaseProvider =
    Provider<DeleteItemInCartUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return DeleteItemInCartUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class DeleteItemInCartUsecase extends UseCase<CartRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  DeleteItemInCartUsecase(
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
      final cartMedicineId = request.cartMedicineId;

      final collectCartMedicine =
          fireCloudStore.collection('cart').doc(cartId).collection("medicine");

      await collectCartMedicine.doc(cartMedicineId).delete();

      final isEmpty =
          (await collectCartMedicine.get().then((value) => value.docs)).isEmpty;

      if (isEmpty) {
        await fireCloudStore.collection('cart').doc(cartId).delete();
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
