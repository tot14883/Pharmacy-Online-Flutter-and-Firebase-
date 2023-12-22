import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/chat/page/chat_screen.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';

class InboxItemWidget extends ConsumerWidget {
  final ChatWithPharmacyResponse chatWithPharmacyItem;

  const InboxItemWidget({
    super.key,
    required this.chatWithPharmacyItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemDate = chatWithPharmacyItem.createAt;
    final currentDate = DateTime.now();
    final chatDate = currentDate.difference(itemDate!).inSeconds < 15;

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
                    url: '${chatWithPharmacyItem.profileImg}',
                    width: 60.w,
                    height: 60.h,
                    radius: BorderRadius.circular(8),
                    fit: BoxFit.cover,
                  ),
                ),
                if (chatWithPharmacyItem.isOnline != null &&
                    chatWithPharmacyItem.isOnline!) ...[
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
                          '${chatWithPharmacyItem.fullName}',
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
                    '${chatWithPharmacyItem.message}',
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
