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
import 'package:pharmacy_online/feature/authentication/model/response/pharmacy_store_response.dart';
import 'package:pharmacy_online/feature/authentication/model/response/user_info_response.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
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
    final userInfo = ref.watch(
      profileControllerProvider.select((value) => value.userInfo),
    );
    final pharmacyStoreInfo = ref.watch(
      profileControllerProvider.select((value) => value.pharmacyStore),
    );

    final pharmacyStoreImg = pharmacyStoreInfo?.storeImg;

    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(
          'รายละเอียดร้านยา',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themeWhiteColor,
      ),
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BaseImageView(
                url: pharmacyStoreImg,
                width: MediaQuery.of(context).size.width,
                height: 333.h,
                fit: BoxFit.cover,
              ),
              StoreDetailContent(
                pharmacyStoreInfo: pharmacyStoreInfo,
                userInfo: userInfo,
              ),
            ],
          ),
        );
      },
    );
  }
}

class StoreDetailContent extends StatelessWidget {
  final PharmacyStoreResponse? pharmacyStoreInfo;
  final UserInfoResponse? userInfo;

  const StoreDetailContent({
    super.key,
    this.pharmacyStoreInfo,
    this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    final nameStore = pharmacyStoreInfo?.nameStore;
    final addressStore = pharmacyStoreInfo?.address;
    final timeOpening = pharmacyStoreInfo?.timeOpening;
    final timeClosing = pharmacyStoreInfo?.timeClosing;
    final fullname = userInfo?.fullName;
    final licensePharmacy = pharmacyStoreInfo?.licensePharmacy;
    final licensePharmacyImg = pharmacyStoreInfo?.licensePharmacyImg;

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
                  'ร้าน $nameStore',
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
              '$addressStore',
              style: AppStyle.txtBody,
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            "เปิด วันจันทร์ - วันเสาร์ เวลา $timeOpening - ปิด เวลา $timeClosing น. ",
            style: AppStyle.txtBody.copyWith(color: AppColor.errorColor),
          ),
          Text(
            "ปิด  ทุกวันอาทิตย์",
            style: AppStyle.txtBody.copyWith(color: AppColor.errorColor),
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            "$fullname เลขที่ใบอนุญาต $licensePharmacy",
            style: AppStyle.txtBody,
          ),
          SizedBox(
            height: 16.h,
          ),
          BaseImageView(
            url: licensePharmacyImg,
            width: 250.w,
            height: 250.h,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 48.h,
          ),
          BaseButton(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(EditPharmacyStoreScreen.routeName);
            },
            text: 'แก้ไขข้อมูลร้าน',
          ),
        ],
      ),
    );
  }
}
