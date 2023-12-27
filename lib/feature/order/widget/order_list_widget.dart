import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_divider.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/feature/cart/model/response/cart_response.dart';
import 'package:pharmacy_online/feature/order/model/response/order_response.dart';
import 'package:pharmacy_online/feature/order/widget/order_item_widget.dart';

class OrderListWidget extends ConsumerWidget {
  final List<CartResponse>? cartList;
  final List<OrderResponse>? orderList;

  const OrderListWidget({super.key, this.cartList, this.orderList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: cartList?.length ?? orderList?.length ?? 0,
      itemBuilder: (context, index) {
        CartResponse? cartItem;
        OrderResponse? orderItem;

        if (cartList != null) {
          cartItem = cartList?[index];
        }

        if (orderList != null) {
          orderItem = orderList?[index];
        }

        return OrderItemWidget(
          cartItem: cartList != null ? cartItem : null,
          orderItem: orderList != null ? orderItem : null,
        );
      },
      separatorBuilder: (_, __) => const BaseDivider(
        bgColor: AppColor.themeGrayLight,
      ),
    );
  }
}
