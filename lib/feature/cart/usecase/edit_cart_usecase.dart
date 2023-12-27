import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/cart/model/request/cart_request.dart';

final editCartUsecaseProvider = Provider<EditCartUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return EditCartUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class EditCartUsecase extends UseCase<CartRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  EditCartUsecase(
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

      final medicineId = request.medicineId;
      final medicineImg = request.medicineImg;
      final medicineName = request.medicineName;
      final medicinePrice = request.medicinePrice;
      final quantity = request.quantity;

      final collectCart = fireCloudStore.collection('cart');

      await collectCart.doc(cartId).update({'update_at': DateTime.now()});

      final collectCartMedicine =
          fireCloudStore.collection('cart').doc(cartId).collection("medicine");

      final _cartMedicineId = collectCartMedicine.doc().id;

      final Map<String, dynamic> myMedicine = {
        "id": cartMedicineId ?? _cartMedicineId,
        "quantity": quantity,
        "medicineImg": medicineImg,
        "medicineName": medicineName,
        "medicinePrice": medicinePrice,
        "medicineId": medicineId,
      };

      if (cartMedicineId != null) {
        await collectCartMedicine.doc(cartMedicineId).update(myMedicine);
      } else {
        await collectCartMedicine.doc(cartMedicineId).set(myMedicine);
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
