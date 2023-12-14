import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/dashboard/page/dashboard_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class SignInSuccessfulScreen extends ConsumerWidget {
  static const routeName = 'SignInSuccessfulScreen';

  const SignInSuccessfulScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      bodyBuilder: (context, constrined) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.icons.icSuccessful.svg(),
              SizedBox(
                height: 32.h,
              ),
              Text(
                'ทำการเข้าสู่ระบบเรียบร้อย',
                style: AppStyle.txtBody2,
              ),
              SizedBox(
                height: 16.h,
              ),
              BaseButton(
                width: 100.w,
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    DashboardScreen.routeName,
                    (route) => false,
                  );
                },
                text: 'ยืนยัน',
              ),
            ],
          ),
        );
      },
    );
  }
}
