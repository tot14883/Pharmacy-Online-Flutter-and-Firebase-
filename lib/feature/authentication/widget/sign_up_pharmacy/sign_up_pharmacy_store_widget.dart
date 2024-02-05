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
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/base_widget/base_upload_image.dart';
import 'package:pharmacy_online/base_widget/base_upload_image_button.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/authentication/controller/authentication_controller.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_sign_up_enum.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class SignUpPharmacyStoreWidget extends ConsumerStatefulWidget {
  static const routeName = 'SignUpPharmacyStoreWidget';

  final Function(XFile? storeFile, XFile? licenseStoreFile, XFile? qrcodeFile)
      onTap;

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
  TextEditingController addressController = TextEditingController();
  XFile? licenseStoreFile, qrcodeFile, storeFile;
  bool isRequiredStore = false,
      isRequiredLicenseStore = false,
      isRequiredQrcode = false;

  @override
  void dispose() {
    super.dispose();
    addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BaseUploadImageButton(
          imgPreview: Assets.icons.icAddImg.svg(),
          onUpload: (val) {
            setState(() {
              storeFile = val;
            });
          },
        ),
        if (isRequiredStore) ...[
          SizedBox(
            height: 8.h,
          ),
          Text(
            'กรุณาเลือกภาพ',
            style: AppStyle.txtError,
          ),
        ],
        SizedBox(
          height: 16.h,
        ),
        BaseTextField(
          fieldKey: FieldSignUp.nameStore,
          label: "ชื่อร้าน",
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
          fieldKey: FieldSignUp.addressStore,
          controller: addressController,
          label: "ที่อยู่",
          isShowLabelField: true,
          isReadOnly: true,
          onTap: () async {
            final result = await ref.read(baseUtilsProvider).getLocation();
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
                              .setLatAndLongPharmacyStore(
                                location.lat,
                                location.lng,
                              );
                        }
                      },
                      onSuggestionSelected: (PlacesDetailsResponse? result) {
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
          label: "เบอร์โทรศัพท์",
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
          fieldKey: FieldSignUp.timeOpening,
          label: "เวลาเปิด",
          isShowLabelField: true,
          textInputType: TextInputType.datetime,
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
          label: "เวลาปิด",
          isShowLabelField: true,
          textInputType: TextInputType.datetime,
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
          label: "เลขที่ใบอนุญาตร้าน",
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
        BaseUploadImage(
          label: 'รูปใบอนุญาต',
          onUpload: (val) {
            setState(() {
              licenseStoreFile = val;
            });
          },
        ),
        if (licenseStoreFile != null) ...[
          SizedBox(
            height: 8.h,
          ),
          BaseImageView(
            file: File(licenseStoreFile!.path),
            width: 250.w,
            height: 250.h,
            fit: BoxFit.cover,
          ),
        ],
        if (isRequiredStore) ...[
          SizedBox(
            height: 8.h,
          ),
          Text(
            'กรุณาเลือกภาพ',
            style: AppStyle.txtError,
          ),
        ],
        SizedBox(
          height: 16.h,
        ),
        BaseUploadImage(
          label: 'QRcode รับเงิน',
          onUpload: (val) {
            setState(() {
              qrcodeFile = val;
            });
          },
        ),
        if (qrcodeFile != null) ...[
          SizedBox(
            height: 8.h,
          ),
          BaseImageView(
            file: File(qrcodeFile!.path),
            width: 250.w,
            height: 250.h,
            fit: BoxFit.cover,
          ),
        ],
        if (isRequiredQrcode) ...[
          SizedBox(
            height: 8.h,
          ),
          Text(
            'กรุณาเลือกภาพ',
            style: AppStyle.txtError,
          ),
        ],
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
                  isRequiredStore = storeFile != null ? false : true;
                  isRequiredLicenseStore =
                      licenseStoreFile != null ? false : true;
                  isRequiredQrcode = qrcodeFile != null ? false : true;
                  setState(() {});

                  if (storeFile != null &&
                      licenseStoreFile != null &&
                      qrcodeFile != null) {
                    licenseStoreFile = widget.onTap(
                      storeFile,
                      licenseStoreFile,
                      qrcodeFile,
                    );
                  }
                },
                text: 'ยืนยัน',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
