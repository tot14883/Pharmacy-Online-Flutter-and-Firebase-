import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/base_widget/rating_start_widget.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/order/widget/card_content_widget.dart';

class AddReviewScreen extends ConsumerStatefulWidget {
  static const routeName = 'AddReviewScreen';

  const AddReviewScreen({super.key});

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends BaseConsumerState<AddReviewScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      bgColor: AppColor.themePrimaryColor,
      appBar: const BaseAppBar(
        bgColor: AppColor.themePrimaryColor,
        title: Text(''),
        elevation: 0,
      ),
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16).r,
            child: CardContentWidget(
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingStartWidget(
                    onRatingUpdate: (val) {},
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    'กดดาวเพื่อให้คะแนน',
                    style: AppStyle.txtHeader3,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  const BaseTextField(
                    placeholder: 'ระบุข้อความรีวิว',
                    maxLines: 5,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  BaseButton(
                    onTap: () {},
                    text: 'ยืนยัน',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
