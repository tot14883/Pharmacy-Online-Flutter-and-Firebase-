import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/cart/model/request/cart_request.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';

final addToCartUsecaseProvider = Provider<AddToCartUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return AddToCartUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class AddToCartUsecase extends UseCase<CartRequest, bool> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  AddToCartUsecase(
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
      final storeId = request.storeId;
      final uid = request.uid;
      final medicineId = request.medicineId;
      final medicineImg = request.medicineImg;
      final medicineName = request.medicineName;
      final medicinePrice = request.medicinePrice;
      final quantity = request.quantity;
      final nameStore = request.nameStore;

      final pharmacyId =
          baseSharedPreference.getString(BaseSharePreferenceKey.userId);

      final getCart = await fireCloudStore
          .collection('cart')
          .where('uid', isEqualTo: uid)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .where('status', isEqualTo: OrderStatus.waitingConfirmOrder.name)
          .get()
          .then((value) => value.docs);

      final collectCart = fireCloudStore.collection('cart');
      final cartId = collectCart.doc().id;
      Map<String, dynamic>? _dataGetCart;

      if (getCart.isNotEmpty) {
        _dataGetCart = getCart.first.data() as Map<String, dynamic>;

        final Map<String, dynamic> myData = {
          "update_at": DateTime.now(),
        };

        await collectCart.doc(_dataGetCart['id']).update(myData);
      } else {
        final Map<String, dynamic> myData = {
          "id": cartId,
          "storeId": storeId,
          "pharmacyId": pharmacyId,
          "uid": uid,
          "nameStore": nameStore,
          "status": OrderStatus.waitingConfirmOrder.name,
          "create_at": DateTime.now(),
          "update_at": DateTime.now(),
        };

        await collectCart.doc(cartId).set(myData);
      }

      final getMedicine = (await fireCloudStore
          .collection('cart')
          .doc(_dataGetCart?['id'] ?? cartId)
          .collection("medicine")
          .where('medicineId', isEqualTo: medicineId)
          .get()
          .then((value) => value.docs));

      final collectCartMedicine = fireCloudStore
          .collection('cart')
          .doc(_dataGetCart?['id'] ?? cartId)
          .collection("medicine");
      final cartMedicineId = collectCartMedicine.doc().id;

      if (getMedicine.isNotEmpty) {
        final _data = getMedicine.first.data();
        final Map<String, dynamic> myMedicine = {
          "quantity": quantity,
          "medicineImg": medicineImg,
          "medicineName": medicineName,
          "medicinePrice": medicinePrice,
          "medicineId": medicineId,
        };
        await collectCartMedicine.doc(_data['id']).update(myMedicine);
      } else {
        final random = Random();
        int randomNumber = random.nextInt(10000);

        final Map<String, dynamic> myMedicine = {
          "id": cartMedicineId,
          "cartNumber": "C$randomNumber",
          "quantity": quantity,
          "medicineImg": medicineImg,
          "medicineName": medicineName,
          "medicinePrice": medicinePrice,
          "medicineId": medicineId,
        };
        await collectCartMedicine.doc(cartMedicineId).set(myMedicine);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
