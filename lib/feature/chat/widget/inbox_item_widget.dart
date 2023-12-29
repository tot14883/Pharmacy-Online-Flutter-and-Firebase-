import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/chat/page/chat_screen.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';
import 'package:pharmacy_online/utils/util/date_format.dart';

class InboxItemWidget extends ConsumerWidget {
  final ChatWithPharmacyResponse chatWithPharmacyItem;

  const InboxItemWidget({
    super.key,
    required this.chatWithPharmacyItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemDate = chatWithPharmacyItem.updateAt;
    final isPharmacy = ref.watch(
      profileControllerProvider.select(
        (value) => value.isPharmacy,
      ),
    );

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          ChatScreen.routeName,
          arguments: ChatArgs(
            chatWithPharmacyItem: chatWithPharmacyItem,
            isPharmacy: isPharmacy,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
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
                          isPharmacy
                              ? '${chatWithPharmacyItem.fullName}'
                              : '${chatWithPharmacyItem.nameStore}',
                          style: AppStyle.txtBody2,
                        ),
                      ),
                      Text(
                        displayTime(itemDate, ref),
                        style: AppStyle.txtBody2
                            .copyWith(color: AppColor.themeGrayLight),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  if (chatWithPharmacyItem.message != null &&
                      chatWithPharmacyItem.message!.isNotEmpty) ...[
                    Text(
                      '${chatWithPharmacyItem.message}',
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: AppStyle.txtBody2
                          .copyWith(color: AppColor.themeGrayLight),
                    ),
                  ],
                  if (chatWithPharmacyItem.message == null &&
                      chatWithPharmacyItem.message!.isEmpty &&
                      chatWithPharmacyItem.chatImg != null &&
                      chatWithPharmacyItem.chatImg!.isNotEmpty) ...[
                    Text(
                      '${chatWithPharmacyItem.chatImg}',
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: AppStyle.txtBody2
                          .copyWith(color: AppColor.themeGrayLight),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String displayTime(
    DateTime? itemDate,
    WidgetRef ref,
  ) {
    final currentDate = DateTime.now();
    final isSecond = currentDate.difference(itemDate!).inSeconds >= 15;
    final isMinute = currentDate.difference(itemDate).inMinutes >= 1;
    final isHour = currentDate.difference(itemDate).inHours >= 1;
    final isDay = currentDate.difference(itemDate).inDays == 1;
    final isDate = currentDate.difference(itemDate).inDays >= 2;

    if (isDate) {
      return ref.read(baseDateFormatterProvider).formatDateWithFreeStyleFormat(
            'DD',
            itemDate,
          );
    }

    if (isDay) {
      return 'Yesterday';
    }

    if (isHour) {
      return ref.read(baseDateFormatterProvider).formatDateWithFreeStyleFormat(
            'hh:mm a',
            itemDate,
          );
    }

    if (isMinute) {
      final result = currentDate.difference(itemDate).inMinutes;

      return '$result นาทีที่แล้ว';
    }

    if (isSecond) {
      final result = currentDate.difference(itemDate).inSeconds;

      return '$result วินาทีที่แล้ว';
    }

    return 'Now';
  }
}
