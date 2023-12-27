import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class BottomNavigationWidget extends ConsumerStatefulWidget {
  final Function(int currentPage) onChange;

  const BottomNavigationWidget({Key? key, required this.onChange})
      : super(key: key);

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState
    extends BaseConsumerState<BottomNavigationWidget> {
  // ignore: prefer_final_fields
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final hasUserInfo = ref
            .watch(profileControllerProvider.select((value) => value.userInfo))
            ?.uid !=
        null;

    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: AppColor.themePrimaryColor,
      unselectedLabelStyle:
          AppStyle.txtCaption.copyWith(color: AppColor.themePrimaryColor),
      selectedLabelStyle:
          AppStyle.txtCaption.copyWith(color: AppColor.themePrimaryColor),
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          activeIcon: Assets.icons.icHome.svg(
            width: 24.w,
            height: 24.h,
            color: AppColor.themePrimaryColor,
          ),
          icon: Assets.icons.icHome.svg(
            width: 24.w,
            height: 24.h,
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          activeIcon: Assets.icons.icOrder.svg(
            width: 24.w,
            height: 24.h,
            color: AppColor.themePrimaryColor,
          ),
          icon: Assets.icons.icOrder.svg(
            width: 24.w,
            height: 24.h,
          ),
          label: "Orders",
        ),
        BottomNavigationBarItem(
          activeIcon: Assets.icons.icChat.svg(
            width: 24.w,
            height: 24.h,
            color: AppColor.themePrimaryColor,
          ),
          icon: Assets.icons.icChat.svg(
            width: 24.w,
            height: 24.h,
          ),
          label: "Chat",
        ),
        BottomNavigationBarItem(
          activeIcon: Assets.icons.icProfile.svg(
            width: 24.w,
            height: 24.h,
            color: AppColor.themePrimaryColor,
          ),
          icon: Assets.icons.icProfile.svg(
            width: 24.w,
            height: 24.h,
          ),
          label: "Profile",
        ),
      ],
      onTap: (value) {
        if (hasUserInfo) {
          setState(() {
            _currentIndex = value;
          });
        } else {
          if (value == 1 || value == 2) {
            setState(() {
              _currentIndex = 0;
            });
          } else {
            setState(() {
              _currentIndex = value;
            });
          }
        }
        widget.onChange(value);
      },
    );
  }
}
