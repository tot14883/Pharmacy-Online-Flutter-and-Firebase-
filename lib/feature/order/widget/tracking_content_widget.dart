import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';

class TrackingContentWidget extends StatelessWidget {
  final String number;
  final String title;
  final String? content;
  final double? contentHeight;
  final bool hasBtn;
  final bool isSuccess;
  final bool isSecondBtn;
  final String btnTxt;
  final VoidCallback? onTap;

  const TrackingContentWidget({
    super.key,
    required this.number,
    required this.title,
    this.content,
    this.contentHeight,
    this.hasBtn = true,
    this.isSuccess = false,
    this.isSecondBtn = true,
    this.btnTxt = '',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2).r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150 / 2),
                color: AppColor.themeGrayLight,
              ),
              child: Text(
                number,
                style: AppStyle.txtCaption
                    .copyWith(color: AppColor.themeWhiteColor),
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Text(
              title,
              style: AppStyle.txtBody,
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(
            12.0,
            8.0,
            0,
            8.0,
          ).r,
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: AppColor.themeGrayLight,
                width: 1.0,
              ),
            ),
          ),
          height: contentHeight,
          child: Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Column(
              crossAxisAlignment:
                  hasBtn ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              mainAxisAlignment:
                  hasBtn ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                if (content != null) ...[
                  Row(
                    children: [
                      Container(
                        height: 1.h,
                        width: 20.w,
                        color: AppColor.themeGrayLight,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        '$content',
                        style: AppStyle.txtCaption
                            .copyWith(color: AppColor.themeGrayLight),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                ],
                if (hasBtn) ...[
                  BaseButton(
                    width: 100.w,
                    onTap: onTap ?? () {},
                    buttonType:
                        isSecondBtn ? ButtonType.secondary : ButtonType.primary,
                    txtColor: AppColor.themeGrayLight,
                    text: btnTxt,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
