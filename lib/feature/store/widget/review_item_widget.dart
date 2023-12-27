import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/reviews_response.dart';
import 'package:pharmacy_online/feature/store/page/comment_screen.dart';
import 'package:pharmacy_online/feature/store/widget/commet_header_widget.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class ReviewItemWidget extends ConsumerWidget {
  final ReviewsResponse reviewItem;
  const ReviewItemWidget({
    super.key,
    required this.reviewItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8).h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BaseImageView(
            url: reviewItem.profileImg,
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
                CommentHeaderWidget(
                  reviewItem: reviewItem,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  '${reviewItem.message}',
                  style: AppStyle.txtCaption
                      .copyWith(color: AppColor.themeGrayLight),
                ),
                SizedBox(
                  height: 8.h,
                ),
                GestureDetector(
                  onTap: () async {
                    await ref
                        .read(storeControllerProvider.notifier)
                        .onGetComment('${reviewItem.id}');

                    Navigator.of(context).pushNamed(
                      CommentScreen.routeName,
                      arguments: CommentArgs(
                        reviewItem: reviewItem,
                      ),
                    );
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
