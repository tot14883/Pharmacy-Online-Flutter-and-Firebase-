import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/base_widget/base_upload_image_button.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
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
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BaseUploadImageButton(
                  imgPreview: Assets.icons.icAddImg.svg(),
                  onUpload: (val) {},
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseTextField(
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
                BaseTextField(
                  placeholder: "จำนวน",
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
                SizedBox(
                  height: 16.h,
                ),
                BaseTextField(
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
                SizedBox(
                  height: 16.h,
                ),
                BaseButton(
                  onTap: () async {},
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
