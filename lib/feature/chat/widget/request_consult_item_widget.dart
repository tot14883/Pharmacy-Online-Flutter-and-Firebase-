import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/chat/page/chat_screen.dart';

class RequestConsultItemWidget extends ConsumerWidget {
  const RequestConsultItemWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            url:
                'https://media.istockphoto.com/id/1344027438/video/rows-with-medicines-and-care-products-in-the-pharmacy.jpg?s=640x640&k=20&c=H2CoMq0cWci4Zf6zgsqbIu77-h-hBCQWJVkyo7olBQM=',
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
                  'Delight Pharmacy',
                  style: AppStyle.txtHeader3,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: BaseButton(
                        onTap: () {
                          Navigator.of(context).pushNamed(ChatScreen.routeName);
                        },
                        text: 'ตอบรับ',
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Expanded(
                      child: BaseButton(
                        onTap: () {},
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
