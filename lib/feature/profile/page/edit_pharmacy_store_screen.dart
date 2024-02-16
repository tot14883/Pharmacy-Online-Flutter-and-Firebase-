import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  TextEditingController openingController = TextEditingController();
  TextEditingController closingController = TextEditingController();

  bool isRequiredStore = false, isRequiredLicenseStore = false;
  TimeOfDay? openingTime, closingTime;

  @override
  void initState() {
    super.initState();
    // อ่านข้อมูลร้านจาก ProfileController และกำหนดค่าให้กับ Textfield
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
    addressController.dispose();
    openingController.dispose();
    closingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูลร้านจาก ProfileController
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
    final licenseStore = pharmacyStoreInfo?.licenseStore;

    List<String> timeOpeningParts = pharmacyStoreInfo!.timeOpening!.split(':');
    int openingHour = int.parse(timeOpeningParts[0]);
    int openingMinute = int.parse(timeOpeningParts[1]);
    List<String> timeClosingParts = pharmacyStoreInfo.timeClosing!.split(':');
    int closinggHour = int.parse(timeClosingParts[0]);
    int closingMinute = int.parse(timeClosingParts[1]);

    openingTime =
        openingTime ?? TimeOfDay(hour: openingHour, minute: openingMinute);
    closingTime =
        closingTime ?? TimeOfDay(hour: closinggHour, minute: closingMinute);

    // สร้างหน้าจอด้วย BaseScaffold
    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        elevation: 0,
        title: Text(
          'แก้ไขข้อมูลร้าน',
          style: AppStyle.txtHeader3,
        ),
      ),
      // สร้าง Body ด้วย SingleChildScrollView เพื่อให้สามารถเลื่อนหน้าจอได้
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
                  // Widget สำหรับอัปโหลดรูปร้าน
                  BaseUploadImageButton(
                    imgPreview: BaseImageView(
                      url: storeFile != null ? null : pharmacyStoreImg,
                      file: storeFile != null ? File(storeFile!.path) : null,
                      width: 350.w,
                      //height: 350.h,
                      fit: BoxFit.cover,
                    ),
                    // Callback เมื่อมีการอัปโหลดรูป
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
                  // Textfield สำหรับชื่อร้าน
                  BaseTextField(
                    fieldKey: FieldUserInfo.nameStore,
                    initialValue: nameStore,
                    label: "ชื่อร้าน",
                    isShowLabelField: true,
                    validator: Validators.combine(
                      [
                        Validators.withMessage(
                          "กรุณากรอกข้อมูล",
                          Validators.isEmpty,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  // Textfield สำหรับที่อยู่ร้าน
                  BaseTextField(
                    fieldKey: FieldUserInfo.addressStore,
                    label: "ที่อยู่",
                    controller: addressController,
                    isReadOnly: true,
                    isShowLabelField: true,
                    // Callback เมื่อที่อยู่ถูกแตะ จะเปิดหน้าต่างเลือกที่อยู่
                    onTap: () async {
                      final result =
                          await ref.read(baseUtilsProvider).getLocation();
                      result.when((success) {
                        // เมื่อได้ข้อมูลที่อยู่ จะนำไปแสดงใน Textfield
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
                                // Callback เมื่อเลือกที่อยู่แล้ว
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
                                // Callback เมื่อเลือกที่อยู่จาก suggestion
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
                          "กรุณากรอกข้อมูล",
                          Validators.isEmpty,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  // Textfield สำหรับเบอร์โทรศัพท์ร้าน
                  BaseTextField(
                    fieldKey: FieldUserInfo.phoneStore,
                    initialValue: phoneStore,
                    label: "เบอร์โทรศัพท์",
                    textInputType: TextInputType.phone,
                    isShowLabelField: true,
                    validator: Validators.combine(
                      [
                        Validators.withMessage(
                          "กรุณากรอกข้อมูล",
                          Validators.isEmpty,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  // Textfield สำหรับเวลาเปิด
                  BaseTextField(
                    key: UniqueKey(),
                    label: "เวลาเปิด",
                    textInputType: TextInputType.datetime,
                    isReadOnly: true,
                    isShowLabelField: true,
                    initialValue:
                        '${openingTime?.hour.toString().padLeft(2, '0')}:${openingTime?.minute.toString().padLeft(2, '0')}',
                    onTap: () async {
                      openingTime = await showTimePicker(
                        context: context,
                        initialTime: openingTime!,
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      );

                      setState(() {});
                    },
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  // Textfield สำหรับเวลาปิด
                  BaseTextField(
                    key: UniqueKey(),
                    label: "เวลาปิด",
                    textInputType: TextInputType.datetime,
                    isShowLabelField: true,
                    isReadOnly: true,
                    initialValue:
                        '${closingTime?.hour.toString().padLeft(2, '0')}:${closingTime?.minute.toString().padLeft(2, '0')}',
                    onTap: () async {
                      openingTime = await showTimePicker(
                        context: context,
                        initialTime: closingTime!,
                        builder: (BuildContext context, Widget? child) {
                          return MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(alwaysUse24HourFormat: true),
                            child: child!,
                          );
                        },
                      );

                      setState(() {});
                    },
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  // Textfield สำหรับเลขที่ใบอนุญาตร้าน
                  BaseTextField(
                    fieldKey: FieldUserInfo.licensePharmacyStore,
                    label: "เลขที่ใบอนุญาตร้าน",
                    initialValue: licenseStore,
                    isShowLabelField: true,
                    validator: Validators.combine(
                      [
                        Validators.withMessage(
                          "กรุณากรอกข้อมูล",
                          Validators.isEmpty,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  // Widget สำหรับอัปโหลดรูปใบอนุญาตร้าน
                  BaseUploadImage(
                    label: 'รูปใบอนุญาตร้าน',
                    onUpload: (val) {
                      setState(() {
                        licenseFile = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  // แสดงรูปใบอนุญาตร้าน
                  BaseImageView(
                    url: licenseFile != null ? null : licensePharmacyStore,
                    file: licenseFile != null ? File(licenseFile!.path) : null,
                    width: 300.w,
                    //height: 250.h,
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
                  // ปุ่มสำหรับยืนยันการแก้ไขข้อมูล
                  BaseButton(
                    onTap: () async {
                      if (openingTime == null || closingTime == null) {
                        Fluttertoast.showToast(
                          msg: "กรุณาระบุเวลาเปิด-ปิด",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                        return;
                      }
                      // เรียกเมธอดใน ProfileController เพื่อทำการแก้ไขข้อมูล
                      final result = await ref
                          .read(profileControllerProvider.notifier)
                          .onUpdatePharmacyStore(
                            licenseFile,
                            storeFile,
                            openingTime!,
                            closingTime!,
                          );

                      if (result) {
                        // ทำการโหลดข้อมูลผู้ใช้และข้อมูลร้านใหม่
                        await ref
                            .read(profileControllerProvider.notifier)
                            .onGetUserInfo();
                        await ref
                            .read(profileControllerProvider.notifier)
                            .onGetPharmacyStore();

                        // แจ้ง Notification ว่าต้องให้ Admin อนุมัติให้ใหม่ถ้าแก้ไขข้อมูล
                        await ref
                            .read(homeControllerProvider.notifier)
                            .onPostNotification(
                              'เนื่องจากคุณแก้ไขข้อมูลร้านต้องรอแอดมินอนุมัติใหม่อีกครั้ง',
                              OrderStatus.completed.name,
                              '$uid',
                            );

                        // แสดง Dialog แจ้งเตือนเมื่อแก้ไขสำเร็จ
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
