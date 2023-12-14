import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/rating_start_widget.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/profile/page/edit_pharmacy_store_screen.dart';
import 'package:pharmacy_online/feature/store/page/review_store_screen.dart';

class StoreDetailScreen extends ConsumerStatefulWidget {
  static const routeName = 'StoreDetailScreen';

  const StoreDetailScreen({super.key});

  @override
  _StoreDetailScreenState createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends BaseConsumerState<StoreDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(
          'รายละเอียดร้านยา',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themeWhiteColor,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(EditPharmacyStoreScreen.routeName);
            },
            child: Padding(
              padding: const EdgeInsets.all(16).r,
              child: Text(
                'แก้ไข',
                style: AppStyle.txtBody2,
              ),
            ),
          ),
        ],
      ),
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BaseImageView(
                url:
                    'https://media.istockphoto.com/id/1135284188/photo/if-you-need-its-here.jpg?s=612x612&w=0&k=20&c=2yfZHUqTEGW4-5r4Sc4pzWKx0DtubpdbTkX3h_w1AJg=',
                width: MediaQuery.of(context).size.width,
                height: 333.h,
                fit: BoxFit.cover,
              ),
              StoreDetailContent(
                onTap: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}

class StoreDetailContent extends StatelessWidget {
  final VoidCallback onTap;

  const StoreDetailContent({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'ร้าน เพื่อนเภสัช',
                  style: AppStyle.txtBody,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(ReviewStoreScreen.routeName);
                },
                child: RatingStartWidget(
                  itemSize: 24,
                  onRatingUpdate: (val) {},
                  isReadable: true,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.h,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Text(
              "616 ถนน ประชารัษฎร์ ตำบล สวนใหญ่ อำเภอ เมืองนนทบุรี 11000",
              style: AppStyle.txtBody,
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            "เปิด วันจันทร์ - วันเสาร์ เวลา 08.00 - 20.00 น.",
            style: AppStyle.txtBody,
          ),
          Text(
            "ปิด  ทุกวันอาทิตย์",
            style: AppStyle.txtBody,
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            "ภก. ธีรวัฒน์ คุณวันดี เลขที่ใบอนุญาต 27819",
            style: AppStyle.txtBody,
          ),
          SizedBox(
            height: 48.h,
          ),
          BaseButton(
            onTap: onTap,
            text: 'ส่งคำขอสนทนา',
          ),
        ],
      ),
    );
  }
}
