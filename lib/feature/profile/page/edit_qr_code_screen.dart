import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class EditQRCodeScreen extends ConsumerStatefulWidget {
  static const routeName = 'EditQRCodeScreen';

  const EditQRCodeScreen({super.key});

  @override
  _EditQRCodeScreenState createState() => _EditQRCodeScreenState();
}

class _EditQRCodeScreenState extends BaseConsumerState<EditQRCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        elevation: 0,
        title: Text(
          'แก้ไข QR Code',
          style: AppStyle.txtHeader3,
        ),
      ),
      bodyBuilder: (context, constrained) {
        return Container(
          padding: const EdgeInsets.all(16).r,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8).r,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.themePrimaryColor,
                    width: 1, // red as border color
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      16,
                    ),
                  ),
                ),
                child: Assets.imgs.imgQrcode.image(),
              ),
              SizedBox(
                height: 16.h,
              ),
              BaseButton(
                onTap: () {},
                text: 'อัพโหลดรูป',
                buttonType: ButtonType.secondary,
              ),
              SizedBox(
                height: 16.h,
              ),
              BaseButton(
                onTap: () {},
                text: 'ยืนยัน',
              ),
            ],
          ),
        );
      },
    );
  }
}
