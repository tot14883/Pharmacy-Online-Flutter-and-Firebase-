import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/home/page/notification_screen.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class UserProfileHeaderWidget extends ConsumerWidget {
  const UserProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      profileControllerProvider.select((value) => value.userInfo),
    );

    final profileImg = userInfo?.profileImg;
    final fullname = userInfo?.fullName;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16).r,
      color: AppColor.themePrimaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BaseImageView(
            url: '$profileImg',
            width: 55,
            height: 55,
            fit: BoxFit.cover,
            radius: const BorderRadius.all(Radius.circular(150 / 2)),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            child: Text(
              'Hello, $fullname',
              style: AppStyle.txtBody2,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(NotificationScreen.routeName);
            },
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(16).r,
                  decoration: const BoxDecoration(
                    color: AppColor.themeWhiteColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(150 / 2),
                    ),
                  ),
                  child: Assets.icons.icNotification.svg(
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4).w,
                    decoration: const BoxDecoration(
                      color: AppColor.errorColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(150 / 2),
                      ),
                    ),
                    child: Text(
                      '3',
                      style: AppStyle.txtError.copyWith(
                        color: AppColor.themeWhiteColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
