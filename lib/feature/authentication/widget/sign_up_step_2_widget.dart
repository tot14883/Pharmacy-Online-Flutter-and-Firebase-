import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_switch_button.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/base_widget/base_upload_image.dart';
import 'package:pharmacy_online/base_widget/base_upload_image_button.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/authentication/controller/authentication_controller.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_sign_up_enum.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class SignUpStep2Widget extends ConsumerStatefulWidget {
  static const routeName = 'SignUpStep2Widget';

  final Function(XFile? imgProfile, XFile? licenseFile) onTap;
  final VoidCallback onBack;

  const SignUpStep2Widget({
    super.key,
    required this.onTap,
    required this.onBack,
  });

  @override
  _SignUpStep2WidgetState createState() => _SignUpStep2WidgetState();
}

class _SignUpStep2WidgetState extends ConsumerState<SignUpStep2Widget> {
  XFile? licenseFile;
  XFile? imgProfile;
  bool isRequiredProfile = false;
  bool isRequiredLicensePharmacy = false;
  TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    addressController.dispose();
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

        final role = baseFormData
            ?.getValue<List<SwitchButtonItem>>(FieldSignUp.role)
            ?.first
            .value;

        final isPharmacy = role == AuthenticationType.pharmacy.name;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BaseUploadImageButton(
              imgPreview: Assets.icons.icAddImg.svg(),
              onUpload: (val) {
                setState(() {
                  imgProfile = val;
                });
              },
            ),
            if (isRequiredProfile) ...[
              SizedBox(
                height: 8.h,
              ),
              Text(
                'กรุณาเลือกภาพ',
                style: AppStyle.txtError,
              ),
              SizedBox(
                height: 8.h,
              ),
            ],
            SizedBox(
              height: 16.h,
            ),
            BaseTextField(
              fieldKey: FieldSignUp.name,
              label: "ชื่อ-นามสกุล",
              isShowLabelField: true,
              validator: Validators.combine(
                [
                  Validators.withMessage(
                    "กรุณากรอกชื่อ-นามสกุล",
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
              label: "เบอร์โทรศัพท์",
              isShowLabelField: true,
              textInputType: TextInputType.phone,
              validator: Validators.combine(
                [
                  Validators.withMessage(
                    "กรุณากรอกเบอร์โทรศัพท์",
                    Validators.isEmpty,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16.h,
            ),
            if (!isPharmacy) ...[
              BaseTextField(
                fieldKey: FieldSignUp.address,
                controller: addressController,
                label: "ที่อยู่",
                isShowLabelField: true,
                isReadOnly: true,
                onTap: () async {
                  final result =
                      await ref.read(baseUtilsProvider).getLocation();
                  result.when((success) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return MapLocationPicker(
                            apiKey: "AIzaSyAqyETt9iu7l5QioWz5iwEbzrallQrpzLs",
                            popOnNextButtonTaped: true,
                            currentLatLng:
                                LatLng(success.latitude, success.longitude),
                            onNext: (GeocodingResult? result) {
                              if (result != null) {
                                Location location = result.geometry.location;
                                addressController.text =
                                    result.formattedAddress.toString();
                                ref
                                    .read(
                                      authenticationControllerProvider.notifier,
                                    )
                                    .setLatAndLongUser(
                                      location.lat,
                                      location.lng,
                                    );
                              }
                            },
                            onSuggestionSelected:
                                (PlacesDetailsResponse? result) {
                              if (result != null) {
                                setState(() {
                                  result.result.formattedAddress ?? "";
                                });
                              }
                            },
                          );
                        },
                      ),
                    );
                  }, (error) {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return BaseDialog(
                          message: error.message,
                        );
                      },
                    );
                  });
                },
                validator: Validators.combine(
                  [
                    Validators.withMessage(
                      "กรุณาเลือกตำแหน่งที่อยู่",
                      Validators.isEmpty,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
            ],
            if (isPharmacy) ...[
              BaseTextField(
                fieldKey: FieldSignUp.licensePharmacy,
                label: "เลขที่ใบอนุญาตเภสัชกร",
                isShowLabelField: true,
                validator: Validators.combine(
                  [
                    Validators.withMessage(
                      "กรุณากรอกเลขที่ใบอนุญาตเภสัชกร",
                      Validators.isEmpty,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              BaseUploadImage(
                label: 'รูปใบอนุญาตเภสัชกร',
                onUpload: (val) {
                  setState(() {
                    licenseFile = val;
                  });
                },
              ),
              SizedBox(
                height: 8.h,
              ),
              if (licenseFile != null) ...[
                BaseImageView(
                  file: File(licenseFile!.path),
                  width: 300.w,
                  //height: 250.h,
                  fit: BoxFit.cover,
                ),
              ],
              if (isRequiredLicensePharmacy) ...[
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  'กรุณาเลือกภาพ',
                  style: AppStyle.txtError,
                ),
                SizedBox(
                  height: 8.h,
                ),
              ],
              SizedBox(
                height: 16.h,
              ),
            ],
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
                      if (isPharmacy) {
                        isRequiredLicensePharmacy =
                            licenseFile != null ? false : true;
                      }

                      isRequiredProfile = imgProfile != null ? false : true;

                      setState(() {});

                      if (imgProfile != null) {
                        if (isPharmacy && licenseFile == null) {
                          return;
                        }

                        widget.onTap(imgProfile, licenseFile);
                      }
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
