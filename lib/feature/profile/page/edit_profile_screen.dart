import 'package:flutter/widgets.dart';
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
import 'package:pharmacy_online/feature/authentication/enum/field_sign_up_enum.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  static const routeName = 'EditProfileScreen';

  const EditProfileScreen({
    super.key,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
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
          'แก้ไขข้อมูลส่วนตัว',
          style: AppStyle.txtHeader3,
        ),
      ),
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
                  fieldKey: FieldSignUp.email,
                  placeholder: "ชื่อนาม-สกุล",
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
                  fieldKey: FieldSignUp.phone,
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
                // if (!isPharmacy) ...[
                //   BaseTextField(
                //     fieldKey: FieldSignUp.address,
                //     placeholder: "ที่อยู่",
                //     validator: Validators.combine(
                //       [
                //         Validators.withMessage(
                //           "Required",
                //           Validators.isEmpty,
                //         ),
                //       ],
                //     ),
                //   ),
                //   SizedBox(
                //     height: 16.h,
                //   ),
                // ],
                // if (isPharmacy) ...[
                //   BaseTextField(
                //     fieldKey: FieldSignUp.licensePharmacy,
                //     placeholder: "เลขที่ใบอนุญาตเภสัชกร",
                //     validator: Validators.combine(
                //       [
                //         Validators.withMessage(
                //           "Required",
                //           Validators.isEmpty,
                //         ),
                //       ],
                //     ),
                //   ),
                //   SizedBox(
                //     height: 16.h,
                //   ),
                //   BaseUploadImage(
                //     label: 'รูปใบอนุญาต',
                //     onUpload: (val) {
                //       setState(() {
                //         licenseFile = val;
                //       });
                //     },
                //   ),
                //   SizedBox(
                //     height: 16.h,
                //   ),
                // ],
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
