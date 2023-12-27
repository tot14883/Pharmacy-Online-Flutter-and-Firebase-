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
import 'package:pharmacy_online/feature/cart/model/response/cart_response.dart';
import 'package:pharmacy_online/feature/cart/page/my_cart_screen.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';
import 'package:pharmacy_online/feature/store/page/add_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/page/central_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/widget/medicine_warehouse_list_widget.dart';

class MyMedicineWarehouseArgs {
  final bool isFromChat;
  final ChatWithPharmacyResponse? chatWithPharmacyItem;
  final CartResponse? cartResponse;

  MyMedicineWarehouseArgs({
    this.isFromChat = false,
    this.chatWithPharmacyItem,
    this.cartResponse,
  });
}

class MyMedicineWarehouseScreen extends ConsumerStatefulWidget {
  static const routeName = 'MyMedicineWarehouseScreen';

  final MyMedicineWarehouseArgs? args;

  const MyMedicineWarehouseScreen({
    super.key,
    this.args,
  });

  @override
  _MyMedicineWarehouseScreenState createState() =>
      _MyMedicineWarehouseScreenState();
}

class _MyMedicineWarehouseScreenState
    extends BaseConsumerState<MyMedicineWarehouseScreen> {
  @override
  Widget build(BuildContext context) {
    _onListen();

    final isFromChat = widget.args?.isFromChat ?? false;
    final chatWithPharmacyItem = widget.args?.chatWithPharmacyItem;
    final cartResponse = widget.args?.cartResponse;
    final uid = cartResponse?.uid ?? chatWithPharmacyItem?.uid;
    final pharmacyId =
        cartResponse?.pharmacyId ?? chatWithPharmacyItem?.pharmacyId;

    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          'คลังยาร้าน',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themeWhiteColor,
        actions: [
          if (!isFromChat) ...[
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(CentralMedicineWarehouseScreen.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.all(16).r,
                child: Text(
                  'เพิ่มจากคลังยากลาง',
                  style: AppStyle.txtBody2,
                ),
              ),
            ),
          ],
        ],
      ),
      bgColor: AppColor.themeWhiteColor,
      bodyBuilder: (context, constrained) {
        final medicineList = ref.watch(
            storeControllerProvider.select((value) => value.medicineList));

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              AsyncValueWidget(
                value: medicineList,
                data: (_medicineList) {
                  if (_medicineList == null) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      MediaQuery.of(context).padding.bottom,
                    ).r,
                    child: MedicineWarehouseListWidget(
                      isFromChat: isFromChat,
                      medicineList: _medicineList,
                      chatWithPharmacyItem: widget.args?.chatWithPharmacyItem,
                    ),
                  );
                },
              ),
              if (!isFromChat) ...[
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16).r,
                    color: AppColor.themeWhiteColor,
                    child: BaseButton(
                      width: 60.w,
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AddMedicineWarehouseScreen.routeName);
                      },
                      text: 'เพิ่มยา',
                    ),
                  ),
                ),
              ],
              if (isFromChat) ...[
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16).r,
                    color: AppColor.themeWhiteColor,
                    child: BaseButton(
                      width: 60.w,
                      onTap: () async {
                        await ref
                            .read(myCartControllerProvider.notifier)
                            .onGetCart(
                              '$uid',
                              '$pharmacyId',
                              OrderStatus.waitingConfirmOrder,
                            );
                      },
                      text: 'ไปที่หน้าตระกร้า',
                    ),
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }

  void _onListen() {
    ref.listen(myCartControllerProvider, (previous, next) {
      final cartResponse = widget.args?.cartResponse;

      if (next.myCart.value?.id != null) {
        if (cartResponse != null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            MyCartScreen.routeName,
            arguments: MyCartArgs(isPharmacy: true),
            (route) => route.settings.name == MyCartScreen.routeName,
          );
        } else {
          Navigator.of(context).pushNamed(
            MyCartScreen.routeName,
            arguments: MyCartArgs(isPharmacy: true),
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "ไม่มีของในตะกร้า",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    });
  }
}
