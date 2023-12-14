import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/base_widget/base_upload_image.dart';
import 'package:pharmacy_online/base_widget/base_upload_image_button.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_sign_up_enum.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class EditPharmacyStoreScreen extends ConsumerStatefulWidget {
  static const routeName = 'EditPharmacyStoreScreen';

  const EditPharmacyStoreScreen({
    super.key,
  });

  @override
  _EditPharmacyStoreScreenState createState() =>
      _EditPharmacyStoreScreenState();
}

class _EditPharmacyStoreScreenState
    extends ConsumerState<EditPharmacyStoreScreen> {
  final formKey = GlobalKey<BaseFormState>();

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  XFile? licenseFile;

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        elevation: 0,
        title: Text(
          'แก้ไขข้อมูลร้าน',
          style: AppStyle.txtHeader3,
        ),
      ),
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: BaseForm(
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
                    fieldKey: FieldSignUp.nameStore,
                    placeholder: "ชื่อร้าน",
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
                    fieldKey: FieldSignUp.addressStore,
                    placeholder: "ที่อยู่",
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
                    fieldKey: FieldSignUp.phoneStore,
                    placeholder: "เบอร์โทรศัพท์",
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
                    fieldKey: FieldSignUp.timeOpening,
                    placeholder: "เวลาเปิด",
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
                    fieldKey: FieldSignUp.timeClosing,
                    placeholder: "เวลาปิด",
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
                    fieldKey: FieldSignUp.licensePharmacyStore,
                    placeholder: "เลขที่ใบอนุญาตร้าน",
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
                  BaseUploadImage(
                    label: 'รูปใบอนุญาต',
                    onUpload: (val) {
                      setState(() {
                        licenseFile = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  BaseUploadImage(
                    label: 'QRcode รับเงิน',
                    onUpload: (val) {
                      setState(() {
                        licenseFile = val;
                      });
                    },
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
          ),
        );
      },
    );
  }
}
