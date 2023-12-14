import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class BottomNavigationWidget extends StatefulWidget {
  final Function(int currentPage) onChange;

  const BottomNavigationWidget({Key? key, required this.onChange})
      : super(key: key);

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  // ignore: prefer_final_fields
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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
        setState(() {
          _currentIndex = value;
        });
        widget.onChange(value);
      },
    );
  }
}
