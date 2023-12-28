import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/base_widget/base_upload_image_button.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/enum/field_medicine_enum.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class AddMedicineWarehouseScreen extends ConsumerStatefulWidget {
  static const routeName = 'AddMedicineWarehouseScreen';

  const AddMedicineWarehouseScreen({super.key});

  @override
  _AddMedicineWarehouseScreenState createState() =>
      _AddMedicineWarehouseScreenState();
}

class _AddMedicineWarehouseScreenState
    extends BaseConsumerState<AddMedicineWarehouseScreen> {
  final formKey = GlobalKey<BaseFormState>();

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  XFile? medicineFIle;

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref
            .read(baseSharePreferenceProvider)
            .getString(BaseSharePreferenceKey.role) ==
        AuthenticationType.admin.name;

    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          'เพิ่มยา',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themeWhiteColor,
      ),
      bgColor: AppColor.themeWhiteColor,
      bodyBuilder: (context, constrained) {
        return BaseForm(
          key: formKey,
          onChanged: ref.read(storeControllerProvider.notifier).onChanged,
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BaseUploadImageButton(
                  imgPreview: Assets.icons.icAddImg.svg(),
                  onUpload: (val) {
                    setState(() {
                      medicineFIle = val;
                    });
                  },
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseTextField(
                  fieldKey: FieldMedicine.name,
                  placeholder: "ชื่อยา",
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
                // BaseTextField(
                //   placeholder: "จำนวน",
                //   textInputType: TextInputType.number,
                //   validator: Validators.combine(
                //     [
                //       Validators.withMessage(
                //         "Required",
                //         Validators.isEmpty,
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 16.h,
                // ),
                if (!isAdmin) ...[
                  BaseTextField(
                    fieldKey: FieldMedicine.price,
                    placeholder: "ราคา",
                    textInputType: TextInputType.number,
                    validator: Validators.combine(
                      [
                        Validators.withMessage(
                          "Required",
                          Validators.isEmpty,
                        ),
                      ],
                    ),
                  ),
                ],
                SizedBox(
                  height: 16.h,
                ),
                BaseButton(
                  onTap: () async {
                    formKey.currentState?.save(
                      onSave: (_) async {
                        if (medicineFIle == null) {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message: 'กรุณาเลือกรูปภาพ',
                              );
                            },
                          );
                          return;
                        }

                        final result = await ref
                            .read(storeControllerProvider.notifier)
                            .addMedicineWarehouse(medicineFIle!);

                        if (result) {
                          await ref
                              .read(storeControllerProvider.notifier)
                              .onGetCentralMedicineWarehouse();
                          await ref
                              .read(storeControllerProvider.notifier)
                              .onGetMedicineWarehouse();

                          showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message: 'เพิ่มยาสำเร็จ',
                                onClick: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message: 'เพิ่มยาไม่สำเร็จ',
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                  text: 'ยืนยัน',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
