import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_divider.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/rating_start_widget.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/page/store_detail_screen.dart';
import 'package:pharmacy_online/feature/store/widget/review_list_widget.dart';

class ReviewStoreScreen extends ConsumerStatefulWidget {
  static const routeName = 'ReviewStoreScreen';
  final StoreDetailArgs? args;

  const ReviewStoreScreen({
    super.key,
    this.args,
  });

  @override
  _ReviewStoreScreenState createState() => _ReviewStoreScreenState();
}

class _ReviewStoreScreenState extends BaseConsumerState<ReviewStoreScreen> {
  @override
  Widget build(BuildContext context) {
    final reviewList = ref
        .watch(storeControllerProvider.select((value) => value.reviewList))
        .value;
        //หาค่าเฉลี่ย review
    final rating = reviewList?.fold(
            0.0,
            (previousValue, val) =>
                (((val.rating ?? 0.0) + previousValue) / reviewList.length)) ??
        0.0;
    final countReview = reviewList?.length;
    final pharmacyInfoResponse = widget.args?.pharmacyInfoResponse;

    final pharmacyStoreInfo = ref.watch(
      profileControllerProvider.select((value) => value.pharmacyStore),
    );

    final nameStore =
        pharmacyInfoResponse?.nameStore ?? pharmacyStoreInfo?.nameStore;
    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(
          'ร้าน $nameStore',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themeWhiteColor,
      ),
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '($countReview)',
                      style: AppStyle.txtBody,
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      'total reviews',
                      style: AppStyle.txtCaption
                          .copyWith(color: AppColor.themeGrayLight),
                    ),
                  ],
                ),
                RatingStartWidget(
                  isReadable: true,
                  initialRating: rating,
                  onRatingUpdate: (val) {},
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  '$rating',
                  style: AppStyle.txtBody,
                ),
                SizedBox(
                  height: 24.h,
                ),
                const BaseDivider(),
                if (reviewList != null) ...[
                  ReviewListWidget(
                    reviewList: reviewList,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
