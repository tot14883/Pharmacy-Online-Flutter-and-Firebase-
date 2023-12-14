import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/store/widget/commet_header_widget.dart';

class CommentItemWidget extends StatelessWidget {
  const CommentItemWidget({super.key});

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
            width: 4.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CommentHeaderWidget(
                  isShowRating: false,
                ),
                Text(
                  'Very useful and great pharmacy, They have the best support ever',
                  style: AppStyle.txtBody2
                      .copyWith(color: AppColor.themeGrayLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
