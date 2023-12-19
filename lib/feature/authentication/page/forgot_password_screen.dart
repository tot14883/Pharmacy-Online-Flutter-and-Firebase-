import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/authentication/controller/authentication_controller.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_forgot_password_enum.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  static const routeName = 'ForgotPasswordScreen';

  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final formKey = GlobalKey<BaseFormState>();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    formKey.currentState?.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(
          'ลืมรหัสผ่าน',
          style: AppStyle.txtHeader3,
        ),
        elevation: 0.0,
        bgColor: Colors.transparent,
      ),
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: BaseForm(
              key: formKey,
              onChanged:
                  ref.read(authenticationControllerProvider.notifier).onChanged,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BaseTextField(
                    fieldKey: FieldForgotPassword.email,
                    label: 'Email Address',
                    controller: emailController,
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
                  BaseButton(
                    onTap: () {
                      formKey.currentState?.save(
                        onSave: (val) async {
                          final result = await ref
                              .read(authenticationControllerProvider.notifier)
                              .onForgotPassword();

                          if (result) {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return BaseDialog(
                                  message: "กรุณาดำเนินการผ่านทางอีเมล",
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return BaseDialog(
                                  message: "เกิดปัญหากรุณาลองใหม่อีกครั้ง",
                                );
                              },
                            );
                          }
                          emailController.clear();
                        },
                      );
                    },
                    text: 'ยืนยัน',
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
