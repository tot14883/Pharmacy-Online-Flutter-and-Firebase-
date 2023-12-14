import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/base_widget/base_upload_image.dart';
import 'package:pharmacy_online/base_widget/base_upload_image_button.dart';
import 'package:pharmacy_online/feature/authentication/controller/authentication_controller.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_sign_up_enum.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class SignUpPharmacyStoreWidget extends ConsumerStatefulWidget {
  static const routeName = 'SignUpPharmacyStoreWidget';

  final VoidCallback onTap;
  final VoidCallback onBack;

  const SignUpPharmacyStoreWidget({
    super.key,
    required this.onTap,
    required this.onBack,
  });

  @override
  _SignUpPharmacyStoreWidgetState createState() =>
      _SignUpPharmacyStoreWidgetState();
}

class _SignUpPharmacyStoreWidgetState
    extends ConsumerState<SignUpPharmacyStoreWidget> {
  XFile? licenseFile;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final baseFormData = ref.watch(
          authenticationControllerProvider.select(
            (value) => value.baseFormData,
          ),
        );

        // final role = baseFormData
        //     ?.getValue<List<SwitchButtonItem>>(FieldSignUp.role)
        //     ?.first
        //     .value;

        // final isPharmacy = role == AuthenticationType.pharmacy.name;

        return Column(
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
            Row(
              children: [
                Expanded(
                  child: BaseButton(
                    buttonType: ButtonType.secondary,
                    onTap: () async {
                      widget.onBack();
                    },
                    text: 'กลับ',
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: BaseButton(
                    onTap: () async {
                      widget.onTap();
                    },
                    text: 'ยืนยัน',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
