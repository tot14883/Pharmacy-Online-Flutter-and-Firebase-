import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/rating_start_widget.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/reviews_response.dart';

class CommentHeaderWidget extends ConsumerWidget {
  final bool isShowRating;
  final ReviewsResponse? reviewItem;

  const CommentHeaderWidget({
    super.key,
    this.isShowRating = true,
    this.reviewItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref
        .read(baseSharePreferenceProvider)
        .getString(BaseSharePreferenceKey.userId);
    final isPharmacy = ref
        .watch(profileControllerProvider.select((value) => value.isPharmacy));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '${reviewItem?.fullName}',
          style: AppStyle.txtCaption,
        ),
        if (!isShowRating) ...[
          const Spacer(),
        ],
        if (isShowRating) ...[
          SizedBox(
            width: 4.w, //คะแนนดาว
          ),
          Text(
            '${reviewItem?.rating}',
            style: AppStyle.txtCaption.copyWith(color: AppColor.themeGrayLight),
          ),
          SizedBox(
            width: 4.w, //ดาวในรีวิว
          ),
          Expanded(
            child: RatingStartWidget(
              isReadable: true,
              initialRating: reviewItem?.rating ?? 0.0,
              onRatingUpdate: (val) {},
              itemSize: 12,
            ),
          ),
        ],
        if (isPharmacy || uid == reviewItem?.uid) ...[
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => <PopupMenuItem<String>>[
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(
                  "Delete",
                  style: AppStyle.txtBody2,
                ),
              ),
            ],
            onSelected: (index) async {
              if (index == 'delete') {
                if (isShowRating) {
                  await ref
                      .read(storeControllerProvider.notifier)
                      .onDeleteReview(
                          '${reviewItem?.pharmacyId}', '${reviewItem?.id}');
                  await ref
                      .read(storeControllerProvider.notifier)
                      .onGetReview('${reviewItem?.pharmacyId}');
                  await ref
                      .read(profileControllerProvider.notifier)
                      .onGetPharmacyStore();
                } else {
                  await ref
                      .read(storeControllerProvider.notifier)
                      .onDeleteComment(
                          '${reviewItem?.id}', '${reviewItem?.commentId}');
                  await ref
                      .read(storeControllerProvider.notifier)
                      .onGetComment('${reviewItem?.id}');
                  await ref
                      .read(profileControllerProvider.notifier)
                      .onGetPharmacyStore();
                }

                await ref
                    .read(profileControllerProvider.notifier)
                    .onGetPharmacyStore();
              }
            },
          ),
        ],
      ],
    );
  }
}
