import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/utils/image_picker/image_picker_provider.dart';
import 'package:pharmacy_online/utils/image_picker/model/image_picker_config_request.dart';
import 'package:pharmacy_online/utils/util/base_permission_handler.dart';

class BaseUploadImageButton extends ConsumerStatefulWidget {
  final String? filePath;
  final ImageSource source;
  final Function(XFile? file) onUpload;
  final Widget imgPreview;

  const BaseUploadImageButton({
    super.key,
    this.filePath,
    this.source = ImageSource.gallery,
    required this.onUpload,
    required this.imgPreview,
  });

  @override
  _BaseUploadImageButtonState createState() => _BaseUploadImageButtonState();
}

class _BaseUploadImageButtonState extends ConsumerState<BaseUploadImageButton> {
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final isGrant = await ref
            .read(basePermissionHandlerProvider)
            .requestStoragePermission();

        if (isGrant) {
          final result = await ref.read(imagePickerUtilsProvider).getImage(
                ImagePickerConfigRequest(
                  source: widget.source,
                  maxHeight: 1920,
                  maxWidth: 2560,
                  imageQuality: 30,
                  isMaximum2MB: true,
                ),
              );

          result.when(
            (success) {
              setState(() {
                image = success[0];
              });
              widget.onUpload(success[0]);
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
      child: image != null
          ? BaseImageView(
              file: File(image!.path),
              width: 150.w,
              height: 150.h,
            )
          : widget.filePath != null
              ? BaseImageView(
                  url: widget.filePath,
                  width: 250.w,
                  height: 250.h,
                )
              : widget.imgPreview,
    );
  }
}
