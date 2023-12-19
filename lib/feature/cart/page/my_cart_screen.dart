import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/cart/page/address_delivery_screen.dart';
import 'package:pharmacy_online/feature/cart/page/order_summary_screen.dart';
import 'package:pharmacy_online/feature/cart/widget/cart_list_widget.dart';
import 'package:pharmacy_online/feature/order/widget/row_content_widget.dart';

class MyCartArgs {
  final bool isPharmacy;

  MyCartArgs({
    this.isPharmacy = false,
  });
}

class MyCartScreen extends ConsumerStatefulWidget {
  static const routeName = 'MyCartScreen';

  final MyCartArgs args;

  const MyCartScreen({super.key, required this.args});

  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends BaseConsumerState<MyCartScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          'My Cart',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themeWhiteColor,
      ),
      bgColor: AppColor.themeWhiteColor,
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CartListWidget(isPharmacy: widget.args.isPharmacy),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  'Payment Detail',
                  style: AppStyle.txtBody,
                ),
                SizedBox(
                  height: 8.h,
                ),
                const RowContentWidget(
                  header: 'Subtotal',
                  content: '72.10 บาท',
                ),
                SizedBox(
                  height: 8.h,
                ),
                const RowContentWidget(
                  header: 'Vat7%',
                  content: '1.89 บาท',
                ),
                SizedBox(
                  height: 8.h,
                ),
                const RowContentWidget(
                  header: 'Total',
                  content: '73.99 บาท',
                  isBold: true,
                ),
                SizedBox(
                  height: 24.h,
                ),
                BaseButton(
                  onTap: () {
                    if (widget.args.isPharmacy) {
                      Navigator.of(context)
                          .pushNamed(OrderSummaryScreen.routeName);
                      return;
                    }
                    Navigator.of(context)
                        .pushNamed(AddressDeliveryScreen.routeName);
                  },
                  text: 'ต่อไป',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
