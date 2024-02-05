import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_switch_button.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/feature/authentication/controller/authentication_controller.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_sign_up_enum.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_in_screen.dart';
import 'package:pharmacy_online/feature/authentication/widget/row_text_clickable_widget.dart';
import 'package:pharmacy_online/feature/main/page/main_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class SignUpStep1Widget extends ConsumerStatefulWidget {
  static const routeName = 'SignUpStep1Widget';

  final VoidCallback onTap;

  const SignUpStep1Widget({
    super.key,
    required this.onTap,
  });

  @override
  _SignUpStep1WidgetState createState() => _SignUpStep1WidgetState();
}

class _SignUpStep1WidgetState extends ConsumerState<SignUpStep1Widget> {
  bool isHidePassword = false;
  bool isHidePasswordConfirm = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isEmailAlready = false;
  bool isPasswordMatch = true;

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final baseFormData = ref.watch(
          authenticationControllerProvider.select(
            (value) => value.baseFormData,
          ),
        );

        final email = baseFormData?.getValue<String>(FieldSignUp.email);
        final password = baseFormData?.getValue<String>(FieldSignUp.password);
        final confirmPassword =
            baseFormData?.getValue<String>(FieldSignUp.confirmPassword);
        final role = baseFormData
            ?.getValue<List<SwitchButtonItem>>(FieldSignUp.role)
            ?.first;

        if (password != null && confirmPassword != null) {
          passwordController.text = password;
          confirmPasswordController.text = confirmPassword;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseTextField(
              initialValue: email,
              fieldKey: FieldSignUp.email,
              prefixIcon: Assets.icons.icEmail.svg(),
              label: "Enter email",
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
              errorOrWarningText: isEmailAlready ? 'Email has already' : null,
            ),
            SizedBox(
              height: 16.h,
            ),
            BaseTextField(
              fieldKey: FieldSignUp.password,
              controller: passwordController,
              prefixIcon: Assets.icons.icLock.svg(),
              isShowLabelField: true,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isHidePassword = !isHidePassword;
                  });
                },
                child: isHidePassword
                    ? Assets.icons.icEye.svg()
                    : Assets.icons.icEyeSlash.svg(),
              ),
              isObscureText: !isHidePassword,
              label: "Password",
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
              height: 16.h,
            ),
            BaseTextField(
              fieldKey: FieldSignUp.confirmPassword,
              prefixIcon: Assets.icons.icLock.svg(),
              isShowLabelField: true,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isHidePasswordConfirm = !isHidePasswordConfirm;
                  });
                },
                child: isHidePasswordConfirm
                    ? Assets.icons.icEye.svg()
                    : Assets.icons.icEyeSlash.svg(),
              ),
              controller: confirmPasswordController,
              isObscureText: !isHidePasswordConfirm,
              label: "Confirm Password",
              validator: Validators.combine(
                [
                  Validators.withMessage(
                    "Required",
                    Validators.isEmpty,
                  ),
                ],
              ),
              errorOrWarningText:
                  !isPasswordMatch ? 'Password Not Match' : null,
            ),
            SizedBox(
              height: 16.h,
            ),
            BaseSwitchButton(
              fieldKey: FieldSignUp.role,
              isSwitchButton: true,
              label: "Role",
              minWidth: 100.w,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
              ).w,
              initialValue: [
                role ??
                    const SwitchButtonItem(
                      id: 1,
                      value: 'user',
                      content: "user",
                    ),
              ],
              listItem: const [
                SwitchButtonItem(
                  id: 1,
                  value: 'user',
                  content: "user",
                ),
                SwitchButtonItem(
                  id: 2,
                  value: 'pharmacy',
                  content: "pharmacy",
                ),
              ],
            ),
            SizedBox(
              height: 16.h,
            ),
            BaseButton(
              onTap: () async {
                final result = await ref
                    .read(authenticationControllerProvider.notifier)
                    .checkEmailHasAlready();

                setState(() {
                  isEmailAlready = result;
                });

                if (passwordController.text.length < 6) {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return BaseDialog(
                        message: 'รหัสผ่านต้องมากกว่าหรือเท่ากับ 6 ตัวอักษร',
                      );
                    },
                  );

                  return;
                }

                if (confirmPasswordController.text != passwordController.text) {
                  setState(() {
                    isPasswordMatch = false;
                  });
                  return;
                }

                if (!result) {
                  setState(() {
                    isPasswordMatch = true;
                  });
                  widget.onTap();
                }
              },
              text: 'สมัครสมาชิก',
            ),
            SizedBox(
              height: 16.h,
            ),
            RowTextClickableWidget(
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  SignInScreen.routeName,
                  (route) => route.settings.name == MainScreen.routeName,
                );
              },
              label1: 'มีบัญชีแล้ว?',
              label2: 'เข้าสู่ระบบ',
            ),
          ],
        );
      },
    );
  }
}
