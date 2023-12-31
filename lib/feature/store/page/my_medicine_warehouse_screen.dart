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
  final bool isFromOrder;

  MyMedicineWarehouseArgs({
    this.isFromChat = false,
    this.chatWithPharmacyItem,
    this.cartResponse,
    this.isFromOrder = false,
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
  bool isStayThisPage = true;

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
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            setState(() {
              isStayThisPage = false;
            });
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 16.0,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
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
                      MediaQuery.of(context).padding.bottom + 72,
                    ).r,
                    child: MedicineWarehouseListWidget(
                      onTap: (val) {
                        setState(() {
                          isStayThisPage = val;
                        });
                      },
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
                        final cartResponse = widget.args?.cartResponse;

                        await ref
                            .read(myCartControllerProvider.notifier)
                            .onGetCart(
                              '$uid',
                              '$pharmacyId',
                              OrderStatus.waitingConfirmOrder,
                              cartId: cartResponse?.id,
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
    ref.listen(myCartControllerProvider, (previous, next) async {
      final cartResponse = widget.args?.cartResponse;
      final isFromOrder = widget.args?.isFromOrder;
      if (isStayThisPage) {
        if (next.myCart.value?.id != null) {
          if (cartResponse != null) {
            if (!isFromOrder!) {
              setState(() {
                isStayThisPage = false;
              });
              final result =
                  await Navigator.of(context).pushNamedAndRemoveUntil<bool>(
                MyCartScreen.routeName,
                arguments: MyCartArgs(isPharmacy: true),
                (route) => route.settings.name == MyCartScreen.routeName,
              );
              if (result!) {
                setState(() {
                  isStayThisPage = result;
                });
              }
            }
          } else {
            if (!isFromOrder!) {
              setState(() {
                isStayThisPage = false;
              });
              final result = await Navigator.of(context).pushNamed<bool>(
                MyCartScreen.routeName,
                arguments: MyCartArgs(isPharmacy: true),
              );

              if (result!) {
                setState(() {
                  isStayThisPage = result;
                });
              }
            }
          }
        } else {
          setState(() {
            isStayThisPage = false;
          });
          Fluttertoast.showToast(
            msg: "ไม่มีของในตะกร้า",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    });
  }
}
