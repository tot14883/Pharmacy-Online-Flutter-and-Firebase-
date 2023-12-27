import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/feature/cart/model/response/cart_response.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';

part 'order_response.freezed.dart';
part 'order_response.g.dart';

@immutable
@freezed
abstract class OrderResponse with _$OrderResponse {
  @JsonSerializable()
  const factory OrderResponse({
    String? id,
    String? pharmacyId,
    String? uid,
    String? cartId,
    CartResponse? myCart,
    OrderStatus? status,
    String? diagnose,
    String? orderNumber,
    String? moreDetail,
    String? bankTransferSlip,
    String? deliverySlip,
    String? bankTransferDate,
    double? bankTotalPriceSlip,
    DateTime? createAt,
    DateTime? updateAt,
  }) = _OrderResponse;

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);
}
