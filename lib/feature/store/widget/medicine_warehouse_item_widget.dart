import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/store/page/drug_detail_screen.dart';
import 'package:pharmacy_online/feature/store/page/edit_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class MedicineWarehouseItemWidget extends StatelessWidget {
  final String imgUrl;
  final String name;
  final String? id;
  final String price;
  final bool isCentral;

  const MedicineWarehouseItemWidget({
    super.key,
    required this.imgUrl,
    required this.name,
    this.id,
    required this.price,
    required this.isCentral,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(DrugDetailScreen.routeName);
      },
      child: Row(
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: AppStyle.txtBody,
                      ),
                    ),
                    if (isCentral) ...[
                      BaseButton(
                        width: 50.w,
                        onTap: () {},
                        iconWidget: Padding(
                          padding: const EdgeInsets.only(top: 4).h,
                          child: Assets.icons.icPlus.svg(),
                        ),
                      ),
                    ],
                    if (!isCentral) ...[
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(EditMedicineWarehouseScreen.routeName);
                        },
                        child: Assets.icons.icEdit.svg(),
                      ),
                    ],
                  ],
                ),
                if (!isCentral) ...[
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    price,
                    style: AppStyle.txtBody,
                    textAlign: TextAlign.end,
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
