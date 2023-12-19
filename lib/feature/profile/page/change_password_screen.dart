import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/authentication/controller/authentication_controller.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_change_password_enum.dart';
import 'package:pharmacy_online/feature/main/page/main_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  static const routeName = 'ChangePasswordScreen';

  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends BaseConsumerState<ChangePasswordScreen> {
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  final formKey = GlobalKey<BaseFormState>();
  bool isHideCurrentPassword = false;
  bool isHidePassword = false;
  bool isHidePasswordConfirm = false;

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
          onChanged:
              ref.read(authenticationControllerProvider.notifier).onChanged,
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: Column(
              children: [
                BaseTextField(
                  fieldKey: FieldChangePassword.currentPassword,
                  label: 'Password ปัจจุบัน',
                  isShowLabelField: true,
                  prefixIcon: Assets.icons.icLock.svg(),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isHideCurrentPassword = !isHideCurrentPassword;
                      });
                    },
                    child: isHideCurrentPassword
                        ? Assets.icons.icEye.svg()
                        : Assets.icons.icEyeSlash.svg(),
                  ),
                  isObscureText: !isHideCurrentPassword,
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
                  fieldKey: FieldChangePassword.newPassword,
                  label: 'Password ใหม่',
                  controller: newPassword,
                  isShowLabelField: true,
                  prefixIcon: Assets.icons.icLock.svg(),
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
                  label: 'Confirm Password',
                  controller: confirmPassword,
                  prefixIcon: Assets.icons.icLock.svg(),
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
                  isObscureText: !isHidePasswordConfirm,
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
                  height: 16.h,
                ),
                BaseButton(
                  onTap: () {
                    formKey.currentState?.save(
                      onSave: (val) async {
                        if (newPassword.text != confirmPassword.text) {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message: 'รหัสผ่านไม่ตรงกัน',
                              );
                            },
                          );
                        }

                        final result = await ref
                            .read(authenticationControllerProvider.notifier)
                            .onChangePassword();

                        if (result) {
                          await showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message:
                                    'เปลี่ยนรหัสผ่านเรียบร้อย กรุณา Login ใหม่อีกครั้ง',
                                onClick: () async {
                                  final result = await ref
                                      .read(
                                        authenticationControllerProvider
                                            .notifier,
                                      )
                                      .onLogout();

                                  if (result) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                      MainScreen.routeName,
                                      (route) => false,
                                    );
                                  }
                                },
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message:
                                    'ไม่สามารถเปลี่ยนรหัสผ่านได้ เนื่องจากรหัสไม่ถูกต้อง',
                              );
                            },
                          );
                        }
                      },
                    );
                  },
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
