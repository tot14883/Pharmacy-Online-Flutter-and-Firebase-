import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';
import 'package:pharmacy_online/utils/util/date_format.dart';

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
    //การดึงข้อมูล uid ของผู้ใช้ปัจจุบัน
    final uid = ref
        .read(baseSharePreferenceProvider)
        .getString(BaseSharePreferenceKey.userId);

    //ตรวจสอบว่าข้อความนี้เป็นของผู้ใช้ปัจจุบันหรือไม่
    final isMe = uid == messageItem.uid;

    //ดึงข้อมูลเวลาสร้างและเวลาปรับปรุงของข้อความ
    final createAt = messageItem.createAt;
    final updateAt = messageItem.updateAt;
    String? dateTime;
    String? dateTimeday; //เพิ่มมาเอง

    //แปลงรูปแบบวันที่และเวลา
    if (createAt != null || updateAt != null) {
      final convertDate = ref
          .read(baseDateFormatterProvider)
          .convertStringToDateTime('${createAt ?? updateAt}');

      dateTime = ref
          .read(baseDateFormatterProvider)
          //  .formatDateWithFreeStyleFormat('dd/MM/yyyy HH:mm', convertDate);
          .formatDateWithFreeStyleFormat('HH:mm', convertDate);

      dateTimeday = ref
          .read(baseDateFormatterProvider)
          .formatDateWithFreeStyleFormat('dd/MM/yyyy', convertDate);
    }
    //สร้าง Widget สำหรับแสดงข้อความ
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          //ส่วนวันที่
          if ((messageItem.message != null &&
                  messageItem.message!.isNotEmpty) ||
              (messageItem.chatImg != null &&
                  messageItem.chatImg!.isNotEmpty)) ...[
            Text(
              '$dateTimeday',
              style: AppStyle.txtCaption,
            ),
          ],
          if (messageItem.message != null &&
              messageItem.message!.isNotEmpty) ...[
            Container(
              margin: EdgeInsets.only(
                left: isMe ? 48.w : 0, //ค่าเก่า 48
                right: isMe ? 0 : 48.w,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isMe) ...[
                    //แสดงเวลาถ้าข้อความเป็นของผู้ใช้ปัจจุบัน
                    Text(
                      '$dateTime',
                      style: AppStyle.txtCaption,
                    ),
                    SizedBox(
                      width: 8.w, //กล่องข้อความคนส่ง
                    ),
                  ],
                  Expanded(
                    child: Container(
                      //กล่องสำหรับแสดงข้อความ
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
                        textAlign: isMe ? TextAlign.end : TextAlign.start,
                      ),
                    ),
                  ),
                  if (!isMe) ...[
                    //แสดงเวลาถ้าข้อความเป็นของผู้ใช้ท่านอื่น
                    SizedBox(
                      width: 8.w, //กล่องข้อความคนรับ
                    ),
                    Text(
                      '$dateTime',
                      style: AppStyle.txtCaption,
                    ),
                  ],
                ],
              ),
            ),
          ],
          if (messageItem.chatImg != null &&
              messageItem.chatImg!.isNotEmpty) ...[
            //Widget สำหรับแสดงรูปภาพ
            SizedBox(
              height: 4.h,
            ),
            Container(
              margin: EdgeInsets.only(
                left: isMe ? 32.w : 0,
                right: isMe ? 0 : 32.w,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (isMe) ...[
                    //แสดงเวลาถ้ารูปภาพเป็นของผู้ใช้ปัจจุบัน
                    Text(
                      '$dateTime',
                      style: AppStyle.txtCaption,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                  ],
                  Container(
                    //กล่องสำหรับแสดงรูปภาพ
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
                      width: 140.w,
                      //height: 150.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (!isMe) ...[
                    //แสดงเวลาถ้ารูปภาพเป็นของผู้ใช้คนอื่น
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      '$dateTime',
                      style: AppStyle.txtCaption,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
