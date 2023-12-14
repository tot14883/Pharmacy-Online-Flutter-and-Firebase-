import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/rating_start_widget.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';

class CommentHeaderWidget extends StatelessWidget {
  final bool isShowRating;

  const CommentHeaderWidget({
    super.key,
    this.isShowRating = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'ahmed E.',
          style: AppStyle.txtCaption,
        ),
        if (isShowRating) ...[
          SizedBox(
            width: 4.w,
          ),
          Text(
            '4.0',
            style: AppStyle.txtCaption.copyWith(color: AppColor.themeGrayLight),
          ),
          SizedBox(
            width: 4.w,
          ),
          Expanded(
            child: RatingStartWidget(
              isReadable: true,
              onRatingUpdate: (val) {},
              itemSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}
