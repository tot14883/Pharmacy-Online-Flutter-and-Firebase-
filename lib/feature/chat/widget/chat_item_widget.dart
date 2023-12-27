import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';

class ChatItemWidget extends ConsumerWidget {
  final ChatWithPharmacyResponse messageItem;

  const ChatItemWidget({
    super.key,
    required this.messageItem,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final uid = ref
        .read(baseSharePreferenceProvider)
        .getString(BaseSharePreferenceKey.userId);

    final isMe = uid == messageItem.uid;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (messageItem.message != null &&
              messageItem.message!.isNotEmpty) ...[
            Container(
              margin: EdgeInsets.only(
                left: isMe ? 72.w : 0,
                right: isMe ? 0 : 72.w,
              ),
              padding: const EdgeInsets.all(16).r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isMe ? 12 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 12),
                ),
                color: isMe
                    ? AppColor.themePrimaryColor
                    : AppColor.themeWhiteColor,
              ),
              child: Text(
                '${messageItem.message}',
                style: AppStyle.txtCaption,
              ),
            ),
          ],
          if (messageItem.chatImg != null &&
              messageItem.chatImg!.isNotEmpty) ...[
            SizedBox(
              height: 4.h,
            ),
            Container(
              margin: EdgeInsets.only(
                  left: isMe ? 72.w : 0, right: isMe ? 0 : 72.w),
              padding: const EdgeInsets.all(16).r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isMe ? 12 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 12),
                ),
                color: isMe
                    ? AppColor.themePrimaryColor
                    : AppColor.themeWhiteColor,
              ),
              child: BaseImageView(
                url: messageItem.chatImg,
                width: 150.w,
                height: 150.h,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
