import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/home/model/response/notification_response.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class NotificationItemWidget extends StatelessWidget {
  final NotificationResponse notificationItem;

  const NotificationItemWidget({
    super.key,
    required this.notificationItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColor.themeWhiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Assets.icons.icSuccessStatus.svg(),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
            child: Text(
              "${notificationItem.message}",
              style: AppStyle.txtBody2,
            ),
          ),
        ],
      ),
    );
  }
}
