import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/admin/controller/admin_controller.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';
import 'package:pharmacy_online/feature/admin/page/pharmacy_store_detail_screen.dart';

class PharmacyItemWidget extends ConsumerWidget {
  final PharmacyInfoResponse pharmacyItem;

  const PharmacyItemWidget({
    super.key,
    required this.pharmacyItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                PharmacyStoreDetaillScreen.routeName,
                arguments: PharmacyArgs(
                  pharmacyItem: pharmacyItem,
                ),
              );
            },
            child: Row(
              children: [
                BaseImageView(
                  url: '${pharmacyItem.storeImg}',
                  width: 60.w,
                  height: 70.h,
                  fit: BoxFit.cover,
                  radius: const BorderRadius.all(
                    Radius.circular(150 / 2),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '${pharmacyItem.nameStore}',
                      style: AppStyle.txtBody2,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      statusText('${pharmacyItem.status}'),
                      style: AppStyle.txtBody2.copyWith(
                        color: statusTextColor('${pharmacyItem.status}'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BaseButton(
              width: 80.w,
              onTap: () async {
                ref
                    .read(adminControllerProvider.notifier)
                    .updatePharmacyDetail(true, '${pharmacyItem.uid}');

                await ref
                    .read(adminControllerProvider.notifier)
                    .getPharmacyDetail();
              },
              text: 'อนุมัติ',
            ),
            SizedBox(
              height: 8.h,
            ),
            BaseButton(
              width: 80.w,
              buttonType: ButtonType.danger,
              onTap: () async {
                ref
                    .read(adminControllerProvider.notifier)
                    .updatePharmacyDetail(false, '${pharmacyItem.uid}');

                await ref
                    .read(adminControllerProvider.notifier)
                    .getPharmacyDetail();
              },
              text: 'แบน',
            ),
          ],
        )
      ],
    );
  }

  String statusText(String status) {
    if (status == 'waiting') {
      return 'รออนุมัติ';
    } else {
      return 'ร้านได้รับการอนุญาติแล้ว';
    }
  }

  Color statusTextColor(String status) {
    if (status == 'waiting') {
      return AppColor.themeYellowColor;
    } else {
      return AppColor.themeSuccess;
    }
  }
}
