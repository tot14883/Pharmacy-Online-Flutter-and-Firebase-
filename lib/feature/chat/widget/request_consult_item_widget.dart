import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/chat/page/chat_screen.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';

class RequestConsultItemWidget extends ConsumerStatefulWidget {
  final ChatWithPharmacyResponse chatWithPharmacyItem;

  const RequestConsultItemWidget({
    super.key,
    required this.chatWithPharmacyItem,
  });

  @override
  _RequestConsultItemWidgetState createState() =>
      _RequestConsultItemWidgetState();
}

class _RequestConsultItemWidgetState
    extends BaseConsumerState<RequestConsultItemWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      final itemTime = widget.chatWithPharmacyItem.createAt;
      final currentTime = DateTime.now();
      final isMoreThan5Mins = currentTime.difference(itemTime!).inMinutes >= 5;

      if (isMoreThan5Mins) {
        final result = await ref
            .read(storeControllerProvider.notifier)
            .onApproveChatWithPharmacy(
              false,
              '${widget.chatWithPharmacyItem.id}',
            );

        if (result) {
          await ref.read(homeControllerProvider.notifier).onPostNotification(
                'คำร้องขอถูกยกเลิก เนื่องจากเกินระยะเวลาที่กำหนด',
                'cancelChat',
                '${widget.chatWithPharmacyItem.uid}',
              );
          await ref
              .read(storeControllerProvider.notifier)
              .onGetGetRequestChatWithPharmacy();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(
      profileControllerProvider.select((value) => value.userInfo),
    );

    return Container(
      padding: const EdgeInsets.all(16).r,
      decoration: BoxDecoration(
        color: AppColor.themeWhiteColor,
        borderRadius: BorderRadius.all(
          const Radius.circular(16).r,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BaseImageView(
            url: '${widget.chatWithPharmacyItem.profileImg}',
            width: 80.w,
            height: 80.h,
            fit: BoxFit.cover,
            radius: BorderRadius.circular(16).r,
          ),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${widget.chatWithPharmacyItem.fullName}',
                  style: AppStyle.txtHeader3,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: BaseButton(
                        onTap: () async {
                          final result = await ref
                              .read(storeControllerProvider.notifier)
                              .onApproveChatWithPharmacy(
                                true,
                                '${widget.chatWithPharmacyItem.id}',
                              );

                          if (result) {
                            await ref
                                .read(homeControllerProvider.notifier)
                                .onPostNotification(
                                  '${userInfo?.fullName} ยืนยันคำร้องขอของคุณ',
                                  'approveChat',
                                  '${widget.chatWithPharmacyItem.uid}',
                                );

                            await ref
                                .read(storeControllerProvider.notifier)
                                .onGetGetRequestChatWithPharmacy();

                            final isPharmacy = ref.watch(
                              profileControllerProvider.select(
                                (value) => value.isPharmacy,
                              ),
                            );

                            Navigator.of(context).pushNamed(
                              ChatScreen.routeName,
                              arguments: ChatArgs(
                                chatWithPharmacyItem: chatWithPharmacyItem,
                                isPharmacy: isPharmacy,
                              ),
                            );
                          }
                        },
                        text: 'ตอบรับ',
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      child: BaseButton(
                        onTap: () async {
                          final result = await ref
                              .read(storeControllerProvider.notifier)
                              .onApproveChatWithPharmacy(
                                false,
                                '${widget.chatWithPharmacyItem.id}',
                              );

                          if (result) {
                            await ref
                                .read(homeControllerProvider.notifier)
                                .onPostNotification(
                                  '${userInfo?.fullName} ยกเลิกคำร้องขอของคุณ',
                                  'cancelChat',
                                  '${widget.chatWithPharmacyItem.uid}',
                                );

                            await ref
                                .read(storeControllerProvider.notifier)
                                .onGetGetRequestChatWithPharmacy();
                          }
                        },
                        buttonType: ButtonType.danger,
                        text: 'ปฎิเสธ',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
