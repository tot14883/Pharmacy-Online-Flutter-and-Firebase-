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
import 'package:pharmacy_online/feature/dashboard/page/dashboard_screen.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/order/controller/order_controller.dart';
import 'package:pharmacy_online/feature/order/widget/card_content_widget.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';

class AddReviewScreen extends ConsumerStatefulWidget {
  static const routeName = 'AddReviewScreen';

  const AddReviewScreen({super.key});

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends BaseConsumerState<AddReviewScreen> {
  double? rating = 0.0;
  TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderDetail = ref
        .watch(orderControllerProvider.select((value) => value.orderDetail))
        .value;

    final orderId = orderDetail?.id;
    final pharmacyId = orderDetail?.pharmacyId;
    final uid = orderDetail?.uid;
    final fullname = orderDetail?.myCart?.fullName;

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
                    onRatingUpdate: (val) {
                      setState(() {
                        rating = val;
                      });
                    },
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
                  BaseTextField(
                    controller: messageController,
                    placeholder: 'ระบุข้อความรีวิว',
                    maxLines: 5,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  BaseButton(
                    onTap: () async {
                      final result = await ref
                          .read(storeControllerProvider.notifier)
                          .onAddReview(
                            '$orderId',
                            '$pharmacyId',
                            '$uid',
                            messageController.text,
                            rating ?? 0.0,
                          );

                      if (result) {
                        await ref
                            .read(homeControllerProvider.notifier)
                            .onPostNotification(
                              '$fullname เพิ่มรีวิวให้กับร้านคุณ',
                              'approve',
                              '$pharmacyId',
                            );

                        Navigator.of(context).pushNamedAndRemoveUntil(
                          DashboardScreen.routeName,
                          (route) => false,
                        );
                      }
                    },
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
