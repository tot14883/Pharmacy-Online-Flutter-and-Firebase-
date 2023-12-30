import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/cart/controller/my_cart_controller.dart';
import 'package:pharmacy_online/feature/cart/page/address_delivery_screen.dart';
import 'package:pharmacy_online/feature/cart/widget/cart_list_widget.dart';
import 'package:pharmacy_online/feature/order/widget/row_content_widget.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/page/my_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

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
    _onListen();

    final isPharmacy = ref
        .watch(profileControllerProvider.select((value) => value.isPharmacy));

    final myCart =
        ref.watch(myCartControllerProvider.select((value) => value.myCart));
    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          'My Cart',
          style: AppStyle.txtHeader3,
        ),
        actions: [
          if (widget.args.isPharmacy) ...[
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  MyMedicineWarehouseScreen.routeName,
                  arguments: MyMedicineWarehouseArgs(
                    isFromChat: true,
                    cartResponse: myCart.value,
                  ),
                  (route) => route.settings.name == MyCartScreen.routeName,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8).r,
                child: Assets.icons.icAddShoppingCart.svg(),
              ),
            ),
          ],
        ],
        bgColor: AppColor.themeWhiteColor,
      ),
      bgColor: AppColor.themeWhiteColor,
      bodyBuilder: (context, constrained) {
        return AsyncValueWidget(
          value: myCart,
          data: (_myCart) {
            final medicineList = _myCart?.medicineList;

            final price = medicineList?.fold(0.0, (previous, val) {
                  final totalPrice =
                      (val.price ?? 0.0) * ((val.quantity ?? 0.0) * 1.0);
                  return totalPrice + previous;
                }) ??
                0.0;

            final priceTotal = price;

            return SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16).r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (medicineList != null && _myCart != null) ...[
                      CartListWidget(
                        isPharmacy: isPharmacy,
                        myCart: _myCart,
                        medicineList: medicineList,
                      ),
                    ],
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
                    RowContentWidget(
                      header: 'Subtotal',
                      content: '$priceTotal บาท',
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    const RowContentWidget(
                      header: 'ค่าจัดส่ง',
                      content: '50 บาท',
                    ),
                    // const RowContentWidget(
                    //   header: 'Vat7%',
                    //   content: '1.89 บาท',
                    // ),
                    SizedBox(
                      height: 8.h,
                    ),
                    RowContentWidget(
                      header: 'Total',
                      content: '${priceTotal + 50} บาท',
                      isBold: true,
                    ),
                    if (!isPharmacy) ...[
                      SizedBox(
                        height: 24.h,
                      ),
                      BaseButton(
                        onTap: () {
                          // if (isPharmacy) {
                          //   Navigator.of(context)
                          //       .pushNamed(OrderSummaryScreen.routeName);
                          //   return;
                          // }
                          Navigator.of(context)
                              .pushNamed(AddressDeliveryScreen.routeName);
                        },
                        text: 'ต่อไป',
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onListen() {
    ref.listen(myCartControllerProvider, (previous, next) {
      if (next.myCart.value?.id == null) {
        Fluttertoast.showToast(
          msg: "ไม่มีของในตะกร้า",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );

        Navigator.of(context).pop();
      }
    });
  }
}
