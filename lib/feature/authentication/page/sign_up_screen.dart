import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_switch_button.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/authentication/controller/authentication_controller.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_sign_up_enum.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_up_successful_screen.dart';
import 'package:pharmacy_online/feature/authentication/widget/sign_up_pharmacy/sign_up_pharmacy_store_widget.dart';
import 'package:pharmacy_online/feature/authentication/widget/sign_up_step_1_widget.dart';
import 'package:pharmacy_online/feature/authentication/widget/sign_up_step_2_widget.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  static const routeName = 'SignUpScreen';

  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final formKey = GlobalKey<BaseFormState>();
  int currentStep = 0;
  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 1,
    keepPage: true,
  );

  int stepOfSignUpScreen = 3;

  final titleList = [
    "สมัครสมาชิก",
    "กรอกข้อมูลส่วนตัว",
    "กรอกข้อมูลร้าน",
  ];

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
          titleList[currentStep],
          style: AppStyle.txtHeader3,
        ),
        elevation: 0.0,
        bgColor: Colors.transparent,
      ),
      bodyBuilder: (context, constrained) {
        return BaseForm(
          key: formKey,
          onChanged:
              ref.read(authenticationControllerProvider.notifier).onChanged,
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            itemCount: stepOfSignUpScreen,
            itemBuilder: (context, index) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16).r,
                  child: displayScreen(index),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget displayScreen(int page) {
    switch (page) {
      case 0:
        return SignUpStep1Widget(
          onTap: () {
            formKey.currentState?.save(
              onSave: (val) {
                currentStep += 1;
                onChangePage();
              },
            );
          },
        );
      case 1:
        return SignUpStep2Widget(
          onBack: () {
            currentStep -= 1;
            onChangePage();
          },
          onTap: () {
            final baseFormData = ref.watch(
              authenticationControllerProvider.select(
                (value) => value.baseFormData,
              ),
            );

            final role = baseFormData
                ?.getValue<List<SwitchButtonItem>>(FieldSignUp.role)
                ?.first
                .value;

            // formKey.currentState?.save(
            //   onSave: (val) {
            if (role == AuthenticationType.pharmacy.name) {
              currentStep += 1;
              onChangePage();
              return;
            }

            Navigator.of(context).pushNamedAndRemoveUntil(
              SignUpSuccessfulScreen.routeName,
              (route) => false,
            );
            //   },
            // );
          },
        );
      case 2:
        return SignUpPharmacyStoreWidget(
          onBack: () {
            currentStep -= 1;
            onChangePage();
          },
          onTap: () {
            // formKey.currentState?.save(
            //   onSave: (val) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              SignUpSuccessfulScreen.routeName,
              (route) => false,
            );
            //   },
            // );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void onChangePage() {
    pageController.animateToPage(
      currentStep,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );

    setState(() {});
  }
}
