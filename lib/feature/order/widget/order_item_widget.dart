import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/order/page/order_detail_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(OrderDetailScreen.routeName);
      },
      child: Padding(
        padding: const EdgeInsets.all(16).r,
        child: Row(
          children: [
            Assets.icons.icOrder.svg(),
            SizedBox(
              width: 16.w,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'แมวดำ',
                    style:
                        AppStyle.txtBody2.copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    children: [
                      Text(
                        'เลขที่ออเดอร์: ',
                        style: AppStyle.txtBody2,
                      ),
                      Text(
                        '1580',
                        style: AppStyle.txtBody2.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Row(
                    children: [
                      Text(
                        'สถานะชำระเงิน: ',
                        style: AppStyle.txtBody2,
                      ),
                      Text(
                        'ยืนยันการชำระเงินแล้ว',
                        style: AppStyle.txtBody2.copyWith(
                          color: AppColor.themeSuccess,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
