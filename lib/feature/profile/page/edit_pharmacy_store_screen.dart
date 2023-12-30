import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/profile/enum/field_user_info_enum.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';
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
  XFile? storeFile, licenseFile;
  TextEditingController addressController = TextEditingController();
  bool isRequiredStore = false, isRequiredLicenseStore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final pharmacyStoreInfo = ref.watch(
        profileControllerProvider.select((value) => value.pharmacyStore),
      );

      addressController.text = '${pharmacyStoreInfo?.address}';
      ref
          .read(
            profileControllerProvider.notifier,
          )
          .setLatAndLongPharmacyStore(
            pharmacyStoreInfo?.latitude ?? 0.0,
            pharmacyStoreInfo?.longtitude ?? 0.0,
          );
    });
  }

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyStoreInfo = ref.watch(
      profileControllerProvider.select((value) => value.pharmacyStore),
    );

    final uid = ref
        .read(baseSharePreferenceProvider)
        .getString(BaseSharePreferenceKey.userId);

    final pharmacyStoreImg = pharmacyStoreInfo?.storeImg;
    final licensePharmacyStore = pharmacyStoreInfo?.licenseStoreImg;
    final nameStore = pharmacyStoreInfo?.nameStore;
    final phoneStore = pharmacyStoreInfo?.phoneStore;
    final timeClosing = pharmacyStoreInfo?.timeClosing;
    final timeOpening = pharmacyStoreInfo?.timeOpening;
    final licenseStore = pharmacyStoreInfo?.licenseStore;

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
            onChanged: ref.read(profileControllerProvider.notifier).onChanged,
            child: Padding(
              padding: const EdgeInsets.all(16).r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BaseUploadImageButton(
                    imgPreview: BaseImageView(
                      url: storeFile != null ? null : pharmacyStoreImg,
                      file: storeFile != null ? File(storeFile!.path) : null,
                      width: 350.w,
                      height: 350.h,
                      fit: BoxFit.cover,
                    ),
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
                    fieldKey: FieldUserInfo.nameStore,
                    initialValue: nameStore,
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
                    fieldKey: FieldUserInfo.addressStore,
                    placeholder: "ที่อยู่",
                    controller: addressController,
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
                                currentLatLng:
                                    LatLng(success.latitude, success.longitude),
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
                                        .setLatAndLongPharmacyStore(
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
                  BaseTextField(
                    fieldKey: FieldUserInfo.phoneStore,
                    initialValue: phoneStore,
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
                    fieldKey: FieldUserInfo.timeOpening,
                    placeholder: "เวลาเปิด",
                    initialValue: timeOpening,
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
                    fieldKey: FieldUserInfo.timeClosing,
                    placeholder: "เวลาปิด",
                    initialValue: timeClosing,
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
                    fieldKey: FieldUserInfo.licensePharmacyStore,
                    placeholder: "เลขที่ใบอนุญาตร้าน",
                    initialValue: licenseStore,
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
                    url: licenseFile != null ? null : licensePharmacyStore,
                    file: licenseFile != null ? File(licenseFile!.path) : null,
                    width: 250.w,
                    height: 250.h,
                    fit: BoxFit.cover,
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
                  BaseButton(
                    onTap: () async {
                      final result = await ref
                          .read(profileControllerProvider.notifier)
                          .onUpdatePharmacyStore(licenseFile, storeFile);

                      if (result) {
                        await ref
                            .read(profileControllerProvider.notifier)
                            .onGetUserInfo();
                        await ref
                            .read(profileControllerProvider.notifier)
                            .onGetPharmacyStore();

                        await ref
                            .read(homeControllerProvider.notifier)
                            .onPostNotification(
                              'เนื่องจากคุณแก้ไขข้อมูลร้านต้องรอแอดมินอนุมัติใหม่อีกครั้ง',
                              OrderStatus.completed.name,
                              '$uid',
                            );

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
