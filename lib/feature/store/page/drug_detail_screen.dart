import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/cart/controller/my_cart_controller.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';
import 'package:pharmacy_online/feature/store/widget/quantity_widget.dart';

class DrugDetailArgs {
  final MedicineResponse medicineItem;
  final ChatWithPharmacyResponse? chatWithPharmacyItem;

  DrugDetailArgs({
    required this.medicineItem,
    this.chatWithPharmacyItem,
  });
}

class DrugDetailScreen extends ConsumerStatefulWidget {
  static const routeName = 'DrugDetailScreen';

  final DrugDetailArgs args;

  const DrugDetailScreen({
    super.key,
    required this.args,
  });

  @override
  _DrugDetailScreenState createState() => _DrugDetailScreenState();
}

class _DrugDetailScreenState extends BaseConsumerState<DrugDetailScreen> {
  int quantity = 1;
  double price = 0.0;

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    final name = args.medicineItem.name;
    price = args.medicineItem.price ?? 0.0;
    final image = args.medicineItem.medicineImg;
    final pharmacyInfo = ref.watch(
        profileControllerProvider.select((value) => value.pharmacyStore));

    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(
          'Drug Detail',
          style: AppStyle.txtHeader3,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(true);
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
      ),
      bgColor: AppColor.themLineColor,
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BaseImageView(
                  alignment: Alignment.center,
                  url: image,
                  fit: BoxFit.cover,
                  width: 250.w,
                  height: 250.h,
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  '$name',
                  style: AppStyle.txtHeader3,
                ),
                // SizedBox(
                //   height: 8.h,
                // ),
                // Text(
                //   '50 pcs',
                //   style: AppStyle.txtBody2
                //       .copyWith(color: AppColor.themeGrayLight),
                // ),
                SizedBox(
                  height: 16.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuantityWidget(
                      maximum: 100,
                      onUpdate: (val) {
                        setState(() {
                          quantity = val;
                        });
                      },
                    ),
                    Text(
                      '${price * quantity} บาท',
                      style: AppStyle.txtBody,
                    ),
                  ],
                ),
                SizedBox(
                  height: 32.h,
                ),
                BaseButton(
                  onTap: () async {
                    final result = await ref
                        .read(myCartControllerProvider.notifier)
                        .onAddToCart(
                          '${args.chatWithPharmacyItem?.pharmacyId}',
                          '${args.chatWithPharmacyItem?.uid}',
                          '${args.medicineItem.id}',
                          '$image',
                          price,
                          '$name',
                          quantity,
                          '${pharmacyInfo?.nameStore}',
                        );

                    ref
                        .read(myCartControllerProvider.notifier)
                        .setQuantity('${args.medicineItem.id}', quantity);

                    if (result) {
                      Fluttertoast.showToast(
                        msg: "เพิ่มลงตะกร้าสำเร็จ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  text: 'เพิ่มใส่ตะกร้า',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
