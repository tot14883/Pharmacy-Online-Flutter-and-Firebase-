import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/cart/page/my_cart_screen.dart';
import 'package:pharmacy_online/feature/store/widget/quantity_widget.dart';

class DrugDetailScreen extends ConsumerStatefulWidget {
  static const routeName = 'DrugDetailScreen';

  const DrugDetailScreen({super.key});

  @override
  _DrugDetailScreenState createState() => _DrugDetailScreenState();
}

class _DrugDetailScreenState extends BaseConsumerState<DrugDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(
          'Drug Detail',
          style: AppStyle.txtHeader3,
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
                  url:
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/76/Medicine_Drugs.svg/2560px-Medicine_Drugs.svg.png',
                  fit: BoxFit.cover,
                  width: 250.w,
                  height: 250.h,
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  'Vitamin c Capsule',
                  style: AppStyle.txtHeader3,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  '50 pcs',
                  style: AppStyle.txtBody2
                      .copyWith(color: AppColor.themeGrayLight),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuantityWidget(
                      maximum: 10,
                      onUpdate: (val) {},
                    ),
                    Text(
                      '12.10 บาท',
                      style: AppStyle.txtBody,
                    ),
                  ],
                ),
                SizedBox(
                  height: 32.h,
                ),
                BaseButton(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      MyCartScreen.routeName,
                      arguments: MyCartArgs(isPharmacy: true),
                    );
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
