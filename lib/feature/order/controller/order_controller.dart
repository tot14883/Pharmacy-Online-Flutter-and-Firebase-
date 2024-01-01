import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';
import 'package:pharmacy_online/core/router/app_naviagor.dart';
import 'package:pharmacy_online/feature/order/controller/state/order_state.dart';
import 'package:pharmacy_online/feature/order/enum/field_bank_transfer_enum.dart';
import 'package:pharmacy_online/feature/order/enum/field_order_summary_enum.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/order/model/request/order_request.dart';
import 'package:pharmacy_online/feature/order/usecase/add_order_usecase.dart';
import 'package:pharmacy_online/feature/order/usecase/check_review_already_usecase.dart';
import 'package:pharmacy_online/feature/order/usecase/delete_order_usecase.dart';
import 'package:pharmacy_online/feature/order/usecase/get_all_order_usecase.dart';
import 'package:pharmacy_online/feature/order/usecase/get_order_usecase.dart';
import 'package:pharmacy_online/feature/order/usecase/update_order_usecase.dart';
import 'package:pharmacy_online/feature/order/usecase/upload_bank_transfer_usecase.dart';
import 'package:pharmacy_online/feature/order/usecase/upload_delivery_slip_usecase.dart';
import 'package:pharmacy_online/feature/store/model/request/comment_request.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';

final orderControllerProvider =
    StateNotifierProvider<OrderController, OrderState>(
  (ref) {
    final baseFormData = ref.watch(baseFormDataProvider);
    final baseUtils = ref.watch(baseUtilsProvider);
    final appNavigator = ref.watch(appNavigatorProvider);
    final addOrderUsecase = ref.watch(addOrderUsecaseProvider);
    final getOrderUsecase = ref.watch(getOrderUsecaseProvider);
    final getAllOrderUsecase = ref.watch(getAllOrderUsecaseProvider);
    final updateOrderUsecase = ref.watch(updateOrderUsecaseProvider);
    final deleteOrderUsecase = ref.watch(deleteOrderUsecaseProvider);
    final updatBankTransferUsecase =
        ref.watch(updatBankTransferUsecaseProvider);
    final updatDeliverySlipUsecase =
        ref.watch(updatDeliverySlipUsecaseProvider);
    final checkReviewAlreadyUsecase =
        ref.watch(checkReviewAlreadyUsecaseProvider);

    return OrderController(
      ref,
      const OrderState(),
      baseFormData,
      baseUtils,
      appNavigator,
      addOrderUsecase,
      getOrderUsecase,
      getAllOrderUsecase,
      updateOrderUsecase,
      deleteOrderUsecase,
      updatBankTransferUsecase,
      updatDeliverySlipUsecase,
      checkReviewAlreadyUsecase,
    );
  },
);

class OrderController extends StateNotifier<OrderState> {
  final Ref _ref;
  final BaseFormData _baseFormData;
  final LoaderController _loader;
  final BaseUtils _baseUtils;
  final AppNavigator _appNavigator;
  final AddOrderUsecase _addOrderUsecase;
  final GetOrderUsecase _getOrderUsecase;
  final GetAllOrderUsecase _getAllOrderUsecase;
  final UpdateOrderUsecase _updateOrderUsecase;
  final DeleteOrderUsecase _deleteOrderUsecase;
  final UpdatBankTransferUsecase _updatBankTransferUsecase;
  final UpdatDeliverySlipUsecase _updatDeliverySlipUsecase;
  final CheckReviewAlreadyUsecase _checkReviewAlreadyUsecase;
  OrderController(
    this._ref,
    OrderState state,
    this._baseFormData,
    this._baseUtils,
    this._appNavigator,
    this._addOrderUsecase,
    this._getOrderUsecase,
    this._getAllOrderUsecase,
    this._updateOrderUsecase,
    this._deleteOrderUsecase,
    this._updatBankTransferUsecase,
    this._updatDeliverySlipUsecase,
    this._checkReviewAlreadyUsecase,
  )   : _loader = _ref.read(loaderControllerProvider.notifier),
        super(state);

  void onChanged(BaseFormData baseFormData) {
    final newData = _baseFormData.copyAndMerge(baseFormData);
    state = state.copyWith(baseFormData: newData);
  }

  void clearForm() {
    state = state.copyWith(baseFormData: null);
  }

  Future<bool> onAddOrder(
    String storeId,
    String uid,
    String pharmacyId,
    String cartId,
  ) async {
    bool isSuccess = false;

    final result = await _addOrderUsecase.execute(
      OrderRequest(
        storeId: storeId,
        uid: uid,
        pharmacyId: pharmacyId,
        cartId: cartId,
      ),
    );

    result.when(
      (success) => isSuccess = success,
      (error) => null,
    );

    return isSuccess;
  }

  Future<void> onGetAllOrder(
    bool isPharmacy,
  ) async {
    final result = await _getAllOrderUsecase.execute(
      OrderRequest(
        isPharmacy: isPharmacy,
      ),
    );

    result.when(
      (success) => state = state.copyWith(orderList: AsyncValue.data(success)),
      (error) => state = state.copyWith(orderList: const AsyncValue.data([])),
    );
  }

  Future<void> onGetOrder(
    String uid,
    String pharmacyId,
    OrderStatus status, {
    String? orderId,
    bool isLoading = true,
  }) async {
    if (isLoading) {
      _loader.onLoad();
    }

    final result = await _getOrderUsecase.execute(
      OrderRequest(
        id: orderId,
        uid: uid,
        pharmacyId: pharmacyId,
        status: status,
      ),
    );

    result.when((success) {
      state = state.copyWith(orderDetail: AsyncValue.data(success));
      _loader.onDismissLoad();
    }, (error) {
      state = state.copyWith(orderDetail: const AsyncValue.data(null));
      _loader.onDismissLoad();
    });
  }

  Future<bool> onDeleteOrder(
    String id,
    String cartId,
  ) async {
    bool isSuccess = false;
    _loader.onLoad();

    final result = await _deleteOrderUsecase.execute(
      OrderRequest(id: id, cartId: cartId),
    );

    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

  Future<bool> onUpdateOrder(
    String id,
    String cartId, {
    List<Map<String, String>>? howToUse,
    OrderStatus? status,
  }) async {
    _loader.onLoad();

    bool isSuccess = false;
    final baseFormData = state.baseFormData;

    final diagnose = baseFormData?.getValue<String>(FieldOrderSummary.diagnose);
    final moreDetail =
        baseFormData?.getValue<String>(FieldOrderSummary.moreDetail);

    final result = await _updateOrderUsecase.execute(
      OrderRequest(
        id: id,
        cartId: cartId,
        diagnose: diagnose,
        moreDetail: moreDetail,
        howToUse: howToUse,
        status: status,
      ),
    );

    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

  void setBankTransferDateTime(String bankTransferDateTime) {
    state = state.copyWith(bankTransferDateTime: bankTransferDateTime);
  }

  Future<bool> onUpdatBankTransfer(
    String id,
    String cardId,
    String dateTime,
    XFile evidenceImg,
  ) async {
    _loader.onLoad();
    bool isSuccess = false;
    final baseFormData = state.baseFormData;

    final payPrice = baseFormData?.getValue<String>(FieldBankTransfer.payPrice);

    final result = await _updatBankTransferUsecase.execute(
      OrderRequest(
        id: id,
        cartId: cardId,
        bankTransferDate: dateTime,
        bankTotalPriceSlip: double.parse(payPrice ?? '0.0'),
        bankTransferSlip: evidenceImg,
      ),
    );

    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

  Future<bool> onUpdatDeliverySlip(
    String id,
    String cardId,
    XFile evidenceImg,
  ) async {
    _loader.onLoad();
    bool isSuccess = false;

    final result = await _updatDeliverySlipUsecase.execute(
      OrderRequest(
        id: id,
        cartId: cardId,
        deliverySlip: evidenceImg,
      ),
    );

    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

  Future<void> onCheckReviewAlready(String orderId) async {
    final result = await _checkReviewAlreadyUsecase
        .execute(CommentRequest(orderId: orderId));

    result.when(
      (success) => state = state.copyWith(isAlreadyReview: success),
      (error) => null,
    );
  }

  void clearState() {
    state = state.copyWith();
  }
}
