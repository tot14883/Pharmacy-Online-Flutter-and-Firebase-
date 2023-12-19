import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';

class ProfileImageWidget extends ConsumerWidget {
  final String imageUrl;
  final String label;

  const ProfileImageWidget({
    super.key,
    required this.imageUrl,
    required this.label,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BaseImageView(
          radius: BorderRadius.circular(30),
          url: imageUrl,
          width: 80.w,
          height: 124.h,
          fit: BoxFit.cover,
        ),
        SizedBox(
          height: 16.h,
        ),
        Text(
          label,
          style: AppStyle.txtBody2.copyWith(
            color: AppColor.themePrimaryColor,
          ),
        ),
      ],
    );
  }
}
