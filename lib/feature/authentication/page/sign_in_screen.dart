import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_sign_in_enum.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_in_successful_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/term_and_condition_screen.dart';
import 'package:pharmacy_online/feature/authentication/widget/row_text_clickable_widget.dart';
import 'package:pharmacy_online/feature/main/page/main_screen.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class SignInScreen extends ConsumerStatefulWidget {
  static const routeName = 'SignInScreen';

  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
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
        title: Text(
          'เข้าสู่ระบบ',
          style: AppStyle.txtHeader3,
        ),
        elevation: 0.0,
        bgColor: Colors.transparent,
      ),
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BaseTextField(
                  fieldKey: FieldSignIn.email,
                  label: 'Email Address',
                  isShowLabelField: true,
                  validator: Validators.combine(
                    [
                      Validators.withMessage(
                        "Required",
                        Validators.isEmpty,
                      ),
                      Validators.withMessage(
                        "Email is incorrect format",
                        Validators.isValidEmail,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseTextField(
                  fieldKey: FieldSignIn.password,
                  label: 'Password',
                  isShowLabelField: true,
                  validator: Validators.combine(
                    [
                      Validators.withMessage(
                        "Required",
                        Validators.isEmpty,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'ลืมรหัสผ่าน',
                      style: AppStyle.txtCaption
                          .copyWith(color: AppColor.themePrimaryColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                BaseButton(
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      SignInSuccessfulScreen.routeName,
                      (route) => route.settings.name == MainScreen.routeName,
                    );
                  },
                  text: 'เข้าสู่ระบบ',
                ),
                SizedBox(
                  height: 16.h,
                ),
                RowTextClickableWidget(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      TermAndConditionScreen.routeName,
                      (route) => route.settings.name == MainScreen.routeName,
                    );
                  },
                  label1: 'ยังไม่มีบัญชี',
                  label2: 'สมัครสมาชิก',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
