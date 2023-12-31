import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/cart/model/response/cart_response.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/order/model/request/order_request.dart';
import 'package:pharmacy_online/feature/order/model/response/order_response.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';

final getOrderUsecaseProvider = Provider<GetOrderUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  final baseSharedPreference = ref.watch(baseSharePreferenceProvider);

  return GetOrderUsecase(
    ref,
    fireCloudStore,
    baseSharedPreference,
  );
});

class GetOrderUsecase extends UseCase<OrderRequest, OrderResponse> {
  final FirebaseCloudStore fireCloudStore;
  final BaseSharedPreference baseSharedPreference;

  GetOrderUsecase(
    Ref ref,
    this.fireCloudStore,
    this.baseSharedPreference,
  ) {
    this.ref = ref;
  }

  @override
  Future<OrderResponse> exec(
    OrderRequest request,
  ) async {
    try {
      final uid = request.uid;
      final pharmacyId = request.pharmacyId;
      final status = request.status;

      final getOrderDetail = await fireCloudStore
          .collection('order')
          .where('uid', isEqualTo: uid)
          .where('pharmacyId', isEqualTo: pharmacyId)
          .where('status', isEqualTo: status?.name)
          .orderBy('create_at')
          .get()
          .then((value) => value.docs);

      final orderDetail = getOrderDetail.first.data() as Map<String, dynamic>;

      final getCart = await fireCloudStore
          .collection('cart')
          .where('id', isEqualTo: orderDetail['cartId'])
          .get()
          .then((value) => value.docs);

      final cartData = getCart.first.data() as Map<String, dynamic>;

      final List<MedicineResponse> medicineList = [];

      final collectCartMedicine = await fireCloudStore
          .collection('cart')
          .doc(cartData['id'])
          .collection('medicine')
          .get()
          .then((value) => value.docs);

      for (final itemMedicine in collectCartMedicine) {
        final _dataMedicine = itemMedicine.data();

        medicineList.add(
          MedicineResponse(
            id: _dataMedicine['medicineId'],
            quantity: _dataMedicine['quantity'],
            medicineImg: _dataMedicine['medicineImg'],
            name: _dataMedicine['medicineName'],
            price: _dataMedicine['medicinePrice'],
            howToUse: _dataMedicine['howToUse'],
            cartMedicineId: _dataMedicine['id'],
          ),
        );
      }

      final cartResponse = CartResponse(
        id: cartData['id'],
        pharmacyId: cartData['pharmacyId'],
        cartNumber: cartData['cartNumber'],
        uid: cartData['uid'],
        fullName: cartData['fullName'],
        nameStore: cartData['nameStore'],
        phone: cartData['phone'],
        address: cartData['address'],
        district: cartData['district'],
        subDistrict: cartData['subDistrict'],
        province: cartData['province'],
        postNumber: cartData['postNumber'],
        vatFee: cartData['vatFee'],
        deliveryFee: cartData['deliveryFee'],
        totalPrice: cartData['totalPrice'],
        sumamryPrice: cartData['summaryPrice'],
        medicineList: medicineList,
        status: OrderStatus.values.byName(cartData['status']),
        createAt: (cartData['create_at'] as Timestamp).toDate(),
        updateAt: (cartData['update_at'] as Timestamp).toDate(),
      );

      return OrderResponse(
        id: orderDetail['id'],
        pharmacyId: orderDetail['pharmacyId'],
        uid: orderDetail['uid'],
        cartId: orderDetail['cartId'],
        myCart: cartResponse,
        status: OrderStatus.values.byName(orderDetail['status']),
        diagnose: orderDetail['diagnose'],
        orderNumber: orderDetail['orderNumber'],
        moreDetail: orderDetail['moreDetail'],
        bankTransferSlip: orderDetail['urlBankTransferSlip'],
        deliverySlip: orderDetail['deliverySlip'],
        bankTransferDate: orderDetail['bankTransferDate'],
        bankTotalPriceSlip: orderDetail['bankTotalPriceSlip'],
        createAt: (orderDetail['create_at'] as Timestamp).toDate(),
        updateAt: (orderDetail['update_at'] as Timestamp).toDate(),
      );
    } catch (e) {
      return const OrderResponse();
    }
  }
}
