import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/base_widget/base_upload_image.dart';
import 'package:pharmacy_online/base_widget/base_upload_image_button.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/profile/enum/field_user_info_enum.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';
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
  XFile? licenseFile, imgProfile;
  bool isRequiredProfile = false, isRequiredLicensePharmacy = false;
  TextEditingController addressController = TextEditingController();
  final formKey = GlobalKey<BaseFormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final userInfo = ref.watch(
        profileControllerProvider.select((value) => value.userInfo),
      );

      final pharmacyStoreInfo = ref.watch(
        profileControllerProvider.select((value) => value.pharmacyStore),
      );
      addressController.text =
          '${userInfo?.address ?? pharmacyStoreInfo?.address}';
    });
  }

  @override
  void dispose() {
    super.dispose();
    addressController.dispose();
    formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPharmacy = ref.watch(
      profileControllerProvider.select((value) => value.isPharmacy),
    );
    final userInfo = ref.watch(
      profileControllerProvider.select((value) => value.userInfo),
    );

    final pharmacyStoreInfo = ref.watch(
      profileControllerProvider.select((value) => value.pharmacyStore),
    );

    final profileImg = userInfo?.profileImg;
    final fullname = userInfo?.fullName;
    final phone = userInfo?.phone;
    final licensePharmacy = pharmacyStoreInfo?.licensePharmacy;
    final licensePharmacyImg = pharmacyStoreInfo?.licensePharmacyImg;

    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        elevation: 0,
        title: Text(
          'แก้ไขข้อมูลส่วนตัว',
          style: AppStyle.txtHeader3,
        ),
      ),
      bodyBuilder: (context, constrianed) {
        return SingleChildScrollView(
          child: BaseForm(
            key: formKey,
            onChanged: ref.read(profileControllerProvider.notifier).onChanged,
            child: Padding(
              padding: const EdgeInsets.all(16).r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BaseUploadImageButton(
                    imgPreview: BaseImageView(
                      url: imgProfile != null ? null : profileImg,
                      file: imgProfile != null ? File(imgProfile!.path) : null,
                      width: 350.w,
                      height: 350.h,
                      fit: BoxFit.cover,
                    ),
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
                    fieldKey: FieldUserInfo.name,
                    initialValue: fullname,
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
                    fieldKey: FieldUserInfo.phone,
                    initialValue: phone,
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
                  if (!isPharmacy) ...[
                    BaseTextField(
                      fieldKey: FieldUserInfo.address,
                      controller: addressController,
                      placeholder: "ที่อยู่",
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
                                  apiKey:
                                      "AIzaSyAqyETt9iu7l5QioWz5iwEbzrallQrpzLs",
                                  popOnNextButtonTaped: true,
                                  currentLatLng: LatLng(
                                      success.latitude, success.longitude),
                                  onNext: (GeocodingResult? result) {
                                    if (result != null) {
                                      Location location =
                                          result.geometry.location;
                                      addressController.text =
                                          result.formattedAddress.toString();
                                      ref
                                          .read(
                                            profileControllerProvider.notifier,
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
                            "Required",
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
                      fieldKey: FieldUserInfo.licensePharmacy,
                      initialValue: licensePharmacy,
                      placeholder: "เลขที่ใบอนุญาตเภสัชกร",
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
                    BaseImageView(
                      url: licenseFile != null ? null : licensePharmacyImg,
                      file:
                          licenseFile != null ? File(licenseFile!.path) : null,
                      width: 250.w,
                      height: 250.h,
                      fit: BoxFit.cover,
                    ),
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
                  BaseButton(
                    onTap: () async {
                      final result = await ref
                          .read(profileControllerProvider.notifier)
                          .onUpdateUserInfo(imgProfile, licenseFile);

                      if (result) {
                        await ref
                            .read(profileControllerProvider.notifier)
                            .onGetUserInfo();
                        await ref
                            .read(profileControllerProvider.notifier)
                            .onGetPharmacyStore();

                        showDialog(
                          context: context,
                          builder: (_) {
                            return BaseDialog(
                              message: 'แก้ไขสำเร็จ',
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return BaseDialog(
                              message: 'แก้ไขไม่สำเร็จ',
                            );
                          },
                        );
                      }
                    },
                    text: 'ยืนยันแก้ไข',
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
