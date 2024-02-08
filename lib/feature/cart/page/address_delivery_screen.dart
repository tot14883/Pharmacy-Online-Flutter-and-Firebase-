import 'package:flutter/material.dart';
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
import 'package:pharmacy_online/feature/cart/controller/my_cart_controller.dart';
import 'package:pharmacy_online/feature/cart/enum/field_address_delivery_enum.dart';
import 'package:pharmacy_online/feature/cart/page/order_summary_screen.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class AddressDeliveryScreen extends ConsumerStatefulWidget {
  static const routeName = 'AddressDeliveryScreen';

  const AddressDeliveryScreen({super.key});

  @override
  _AddressDeliveryScreenState createState() => _AddressDeliveryScreenState();
}

class _AddressDeliveryScreenState
    extends BaseConsumerState<AddressDeliveryScreen> {
  final formKey = GlobalKey<BaseFormState>();

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _onListening();
    final userInfo = ref.watch(
      profileControllerProvider.select((value) => value.userInfo),
    );
    final fullName = userInfo?.fullName;
    final phone = userInfo?.phone;
    final address = userInfo?.address;

    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          'ตำแหน่งที่อยู่การจัดส่ง',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themeWhiteColor,
      ),
      bgColor: AppColor.themeWhiteColor,
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: BaseForm(
              key: formKey,
              onChanged: ref.read(myCartControllerProvider.notifier).onChanged,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BaseTextField(
                    fieldKey: FieldAddressDelivery.fullName,
                    initialValue: fullName,
                    label: 'ชื่อ-นามสกุลผู้รับ',
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
                  BaseTextField(
                    fieldKey: FieldAddressDelivery.phone,
                    initialValue: phone,
                    label: 'เบอร์โทรศัพท์ผู้รับ',
                    textInputType: TextInputType.phone,
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
                  BaseTextField(
                    fieldKey: FieldAddressDelivery.address,
                    initialValue: address,
                    label: 'บ้านเลขที่/หมู่บ้าน/อาคาร/ซอย/ถนน ผู้รับ',
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
                  BaseTextField(
                    fieldKey: FieldAddressDelivery.subDistrict,
                    label: 'ตำบล/แขวง',
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
                  BaseTextField(
                    fieldKey: FieldAddressDelivery.district,
                    label: 'อำเภอ/เขต',
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
                  BaseTextField(
                    fieldKey: FieldAddressDelivery.province,
                    label: 'จังหวัด',
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
                  BaseTextField(
                    fieldKey: FieldAddressDelivery.post,
                    label: 'รหัสไปรษณีย์',
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
                        onSave: (_) {
                          Navigator.of(context)
                              .pushNamed(OrderSummaryScreen.routeName);
                        },
                      );
                    },
                    text: 'ถัดไป',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _onListening() {
    ref.listen(myCartControllerProvider.select((value) => value.errMsg),
        (previous, next) {
      if (next != null) {
        showDialog(
            context: context,
            builder: (context) {
              return BaseDialog(
                message: next,
              );
            });
      }
    });
  }
}
