import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/store/page/comment_screen.dart';
import 'package:pharmacy_online/feature/store/widget/commet_header_widget.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class ReviewItemWidget extends StatelessWidget {
  const ReviewItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16).r,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BaseImageView(
            url:
                'https://www.wilsoncenter.org/sites/default/files/media/images/person/james-person-1.jpg',
            width: 60.w,
            height: 70.h,
            radius: BorderRadius.circular(150 / 2),
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CommentHeaderWidget(),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  'Very useful and great pharmacy, They have the best support ever',
                  style: AppStyle.txtCaption
                      .copyWith(color: AppColor.themeGrayLight),
                ),
                SizedBox(
                  height: 8.h,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(CommentScreen.routeName);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Assets.icons.icReply.svg(),
                      SizedBox(
                        width: 8.w,
                      ),
                      Text(
                        'Thank you for your feedback',
                        style: AppStyle.txtCaption
                            .copyWith(color: AppColor.themeGrayLight),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
