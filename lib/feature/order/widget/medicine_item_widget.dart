import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';

class MedicineItemWidget extends StatelessWidget {
  final String imgUrl;
  final String name;
  final String? caption;
  final String quantity;
  final String price;

  const MedicineItemWidget({
    super.key,
    required this.imgUrl,
    required this.name,
    this.caption,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        BaseImageView(
          url: imgUrl,
          width: 80.w,
          height: 80.h,
        ),
        SizedBox(
          width: 16.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppStyle.txtBody,
              ),
              if (caption != null) ...[
                Text(
                  '$caption',
                  style: AppStyle.txtBody2.copyWith(
                    color: AppColor.themeGrayLight,
                  ),
                ),
              ],
              SizedBox(
                height: 16.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      quantity,
                      style: AppStyle.txtBody,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      price,
                      style: AppStyle.txtBody,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
