import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/utils/image_picker/image_picker_provider.dart';
import 'package:pharmacy_online/utils/image_picker/model/image_picker_config_request.dart';
import 'package:pharmacy_online/utils/util/base_permission_handler.dart';

class EditQRCodeScreen extends ConsumerStatefulWidget {
  static const routeName = 'EditQRCodeScreen';

  const EditQRCodeScreen({super.key});

  @override
  _EditQRCodeScreenState createState() => _EditQRCodeScreenState();
}

class _EditQRCodeScreenState extends BaseConsumerState<EditQRCodeScreen> {
  XFile? qrCodeFile;

  @override
  Widget build(BuildContext context) {
    final pharmacyStore = ref.watch(
      profileControllerProvider.select((value) => value.pharmacyStore),
    );

    final qrCodeImg = pharmacyStore?.qrCodeImg;

    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        elevation: 0,
        title: Text(
          'แก้ไข QR Code',
          style: AppStyle.txtHeader3,
        ),
      ),
      bodyBuilder: (context, constrained) {
        return Container(
          padding: const EdgeInsets.all(16).r,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8).r,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.themePrimaryColor,
                    width: 1, // red as border color
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(
                      16,
                    ),
                  ),
                ),
                child: BaseImageView(
                  url: qrCodeFile != null ? null : qrCodeImg,
                  file: qrCodeFile != null ? File(qrCodeFile!.path) : null,
                  width: 350.w,
                  height: 350.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              BaseButton(
                onTap: () async {
                  final isGrant = await ref
                      .read(basePermissionHandlerProvider)
                      .requestStoragePermission();
                  final isGrant31 = await ref
                      .read(basePermissionHandlerProvider)
                      .requestPhotosPermission();
                  if (isGrant || isGrant31) {
                    final result =
                        await ref.read(imagePickerUtilsProvider).getImage(
                              const ImagePickerConfigRequest(
                                source: ImageSource.gallery,
                                maxHeight: 1920,
                                maxWidth: 2560,
                                imageQuality: 30,
                                isMaximum2MB: true,
                              ),
                            );

                    result.when(
                      (success) {
                        setState(() {
                          qrCodeFile = success[0];
                        });
                      },
                      (error) async {
                        await showBaseDialog(
                          context: context,
                          builder: (ctx) {
                            return BaseDialog(
                              message: error.message,
                            );
                          },
                        );
                      },
                    );
                  }
                },
                text: 'อัพโหลดรูป',
                buttonType: ButtonType.secondary,
              ),
              SizedBox(
                height: 16.h,
              ),
              BaseButton(
                onTap: () async {
                  final result = await ref
                      .read(profileControllerProvider.notifier)
                      .onChangeQRCode(qrCodeFile);

                  if (result) {
                    await ref
                        .read(
                          profileControllerProvider.notifier,
                        )
                        .onGetPharmacyStore();

                    await showBaseDialog(
                      context: context,
                      builder: (ctx) {
                        return BaseDialog(
                          message: 'อัพเดทเรียบร้อย',
                        );
                      },
                    );
                  } else {
                    await showBaseDialog(
                      context: context,
                      builder: (ctx) {
                        return BaseDialog(
                          message: 'อัพเดทไม่สำเร็จ',
                        );
                      },
                    );
                  }
                },
                text: 'ยืนยัน',
              ),
            ],
          ),
        );
      },
    );
  }
}
