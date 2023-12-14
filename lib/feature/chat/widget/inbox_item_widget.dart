import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/chat/page/chat_screen.dart';

class InboxItemWidget extends ConsumerWidget {
  const InboxItemWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ChatScreen.routeName);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColor.themeWhiteColor,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4).r,
                  child: BaseImageView(
                    url:
                        'https://www.wilsoncenter.org/sites/default/files/media/images/person/james-person-1.jpg',
                    width: 60.w,
                    height: 60.h,
                    radius: BorderRadius.circular(8),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150 / 2),
                      border: Border.all(
                        color: AppColor.themeWhiteColor,
                        width: 4.0,
                      ),
                      color: AppColor.themeSuccess,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 16.w,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'ร้าน เพื่อนเภสัช',
                          style: AppStyle.txtBody2,
                        ),
                      ),
                      Text(
                        'Now',
                        style: AppStyle.txtBody2
                            .copyWith(color: AppColor.themeGrayLight),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    'Please use the dorfix & vitanim',
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: AppStyle.txtBody2
                        .copyWith(color: AppColor.themeGrayLight),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
