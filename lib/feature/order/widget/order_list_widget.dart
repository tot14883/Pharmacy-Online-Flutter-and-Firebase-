import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_divider.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/feature/order/widget/order_item_widget.dart';

class OrderListWidget extends ConsumerWidget {
  const OrderListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return const OrderItemWidget();
      },
      separatorBuilder: (_, __) => const BaseDivider(
        bgColor: AppColor.themeGrayLight,
      ),
    );
  }
}
