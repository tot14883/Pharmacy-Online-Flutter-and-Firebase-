import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  static const routeName = 'ChangePasswordScreen';

  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends BaseConsumerState<ChangePasswordScreen> {
  final formKey = GlobalKey<BaseFormState>();

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        elevation: 0,
        title: Text(
          'เปลี่ยนรหัสผ่าน',
          style: AppStyle.txtHeader3,
        ),
      ),
      bodyBuilder: (context, constrained) {
        return BaseForm(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: Column(
              children: [
                const BaseTextField(
                  label: 'Password ปัจจุบัน',
                  isShowLabelField: true,
                ),
                SizedBox(
                  height: 16.h,
                ),
                const BaseTextField(
                  label: 'Password ใหม่',
                  isShowLabelField: true,
                ),
                SizedBox(
                  height: 16.h,
                ),
                const BaseTextField(
                  label: 'Confirm Password',
                  isShowLabelField: true,
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseButton(
                  onTap: () {},
                  text: "ยืนยัน",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
