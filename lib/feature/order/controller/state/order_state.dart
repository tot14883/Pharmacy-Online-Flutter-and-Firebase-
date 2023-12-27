import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/feature/order/model/response/order_response.dart';

part 'order_state.freezed.dart';

@freezed
class OrderState with _$OrderState {
  const factory OrderState({
    BaseFormData? baseFormData,
    String? errMsg,
    @Default(AsyncValue.loading()) AsyncValue<OrderResponse?> orderDetail,
    @Default(AsyncValue.loading()) AsyncValue<List<OrderResponse>?> orderList,
    Map<String, int>? quantity,
    String? bankTransferDateTime,
    @Default(false) bool isAlreadyReview,
  }) = _OrderState;
}
