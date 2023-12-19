import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/store/widget/quantity_widget.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class CartItemWidget extends StatelessWidget {
  final bool isPharmacy;

  const CartItemWidget({super.key, required this.isPharmacy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16).r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12).r,
        border: Border.all(
          width: 1.w,
          color: AppColor.themePrimaryColor,
        ),
        color: AppColor.themeWhiteColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BaseImageView(
            url:
                'https://img.freepik.com/free-vector/medicine-bottles-cartoon-style_1308-88387.jpg?size=626&ext=jpg&ga=GA1.1.1222169770.1702512000&semt=ais',
            width: 80.w,
            height: 80.h,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Panadol',
                        style: AppStyle.txtBody,
                      ),
                    ),
                    if (isPharmacy) ...[
                      GestureDetector(
                        onTap: () {},
                        child: Assets.icons.icDelete.svg(),
                      ),
                    ],
                  ],
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  '20pcs',
                  style: AppStyle.txtCaption.copyWith(
                    color: AppColor.themeGrayLight,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                if (isPharmacy) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QuantityWidget(
                        maximum: 10,
                        itemSized: 24,
                        onUpdate: (val) {},
                      ),
                      Text(
                        '15.99 บาท',
                        style: AppStyle.txtBody2,
                      ),
                    ],
                  ),
                ] else ...[
                  Text(
                    'ราคา: 15.99 บาท',
                    style: AppStyle.txtBody2,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
