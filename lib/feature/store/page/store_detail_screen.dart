import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/rating_start_widget.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';
import 'package:pharmacy_online/feature/authentication/model/response/pharmacy_store_response.dart';
import 'package:pharmacy_online/feature/authentication/model/response/user_info_response.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_in_screen.dart';
import 'package:pharmacy_online/feature/chat/controller/chat_controller.dart';
import 'package:pharmacy_online/feature/chat/page/chat_screen.dart';
import 'package:pharmacy_online/feature/dashboard/page/dashboard_screen.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/profile/page/edit_pharmacy_store_screen.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/page/review_store_screen.dart';

class StoreDetailArgs {
  final PharmacyInfoResponse? pharmacyInfoResponse;

  StoreDetailArgs({
    required this.pharmacyInfoResponse,
  });
}

class StoreDetailScreen extends ConsumerStatefulWidget {
  static const routeName = 'StoreDetailScreen';
  final StoreDetailArgs? args;

  const StoreDetailScreen({
    super.key,
    this.args,
  });

  @override
  _StoreDetailScreenState createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends BaseConsumerState<StoreDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final pharmacyStoreInfo = widget.args?.pharmacyInfoResponse;
      final userInfo = ref.watch(
        profileControllerProvider.select((value) => value.userInfo),
      );
      await ref
          .read(storeControllerProvider.notifier)
          .onGetReview('${pharmacyStoreInfo?.uid ?? userInfo?.uid}');

      await ref
          .read(storeControllerProvider.notifier)
          .onCheckRequestChatAlready(
            '${pharmacyStoreInfo?.uid ?? userInfo?.uid}',
          );
      await ref
          .read(storeControllerProvider.notifier)
          .onCheckRequestChatWaiting(
            '${pharmacyStoreInfo?.uid ?? userInfo?.uid}',
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyInfoResponse = widget.args?.pharmacyInfoResponse;
    final userInfo = ref.watch(
      profileControllerProvider.select((value) => value.userInfo),
    );
    final pharmacyStoreInfo = ref.watch(
      profileControllerProvider.select((value) => value.pharmacyStore),
    );

    final pharmacyStoreImg =
        pharmacyInfoResponse?.storeImg ?? pharmacyStoreInfo?.storeImg;

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
                pharmacyInfoResponse: pharmacyInfoResponse,
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

class StoreDetailContent extends ConsumerWidget {
  final PharmacyInfoResponse? pharmacyInfoResponse;
  final PharmacyStoreResponse? pharmacyStoreInfo;
  final UserInfoResponse? userInfo;

  const StoreDetailContent({
    super.key,
    this.pharmacyInfoResponse,
    this.pharmacyStoreInfo,
    this.userInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkRequestChatAlready = ref.watch(
      storeControllerProvider.select((value) => value.checkRequestChatAlready),
    );
    final checkRequestChatWaiting = ref.watch(
      storeControllerProvider.select((value) => value.checkRequestChatWaiting),
    );
    final hasUserInfo = ref
            .watch(
              profileControllerProvider.select((value) => value.userInfo),
            )
            ?.uid !=
        null;
    final reviewList = ref
        .watch(storeControllerProvider.select((value) => value.reviewList))
        .value;

    final rating = reviewList?.fold(0.0,
            (previousValue, val) => ((val.rating ?? 0.0) + previousValue)) ??
        0.0;

    final pharmacyId = pharmacyInfoResponse?.uid ?? pharmacyStoreInfo?.uid;

    final uid = ref
        .read(baseSharePreferenceProvider)
        .getString(BaseSharePreferenceKey.userId);

    final nameStore =
        pharmacyInfoResponse?.nameStore ?? pharmacyStoreInfo?.nameStore;

    final addressStore =
        pharmacyStoreInfo?.address ?? pharmacyInfoResponse?.addressStore;

    final timeOpening =
        pharmacyInfoResponse?.timeOpening ?? pharmacyStoreInfo?.timeOpening;
    final timeClosing =
        pharmacyInfoResponse?.timeClosing ?? pharmacyStoreInfo?.timeClosing;
    final fullname = pharmacyInfoResponse?.fullName ?? userInfo?.fullName;
    final licensePharmacy = pharmacyInfoResponse?.licensePharmacy ??
        pharmacyStoreInfo?.licensePharmacy;
    final licensePharmacyImg = pharmacyInfoResponse?.licensePharmacyImg ??
        pharmacyStoreInfo?.licensePharmacyImg;

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
                  Navigator.of(context).pushNamed(
                    ReviewStoreScreen.routeName,
                    arguments: StoreDetailArgs(
                      pharmacyInfoResponse: pharmacyInfoResponse,
                    ),
                  );
                },
                child: RatingStartWidget(
                  itemSize: 24,
                  initialRating: rating,
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
            "เปิด วันจันทร์ - วันเสาร์ เวลา $timeOpening น. - $timeClosing น. ",
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
          if (pharmacyInfoResponse != null) ...[
            BaseButton(
              onTap: () async {
                if (checkRequestChatWaiting) {
                  return;
                }

                if (checkRequestChatAlready) {
                  final result = await ref
                      .read(chatControllerProvider.notifier)
                      .onGetChatDetail('$pharmacyId', '$uid');
                  final id = result.id;
                  if (id != null && id.isNotEmpty) {
                    Navigator.of(context).pushNamed(
                      ChatScreen.routeName,
                      arguments: ChatArgs(
                        chatWithPharmacyItem: result,
                        isNotification: true,
                      ),
                    );
                  }
                  return;
                }

                if (hasUserInfo) {
                  final result = await ref
                      .read(storeControllerProvider.notifier)
                      .onRequestChatWithPharmacy(
                        '${pharmacyInfoResponse?.uid}',
                      );

                  if (result) {
                    await ref
                        .read(homeControllerProvider.notifier)
                        .onPostNotification(
                          '${userInfo?.fullName} ได้ส่งคำขอปรึกษากับคุณ',
                          'approveChat',
                          '$pharmacyId',
                        );

                    Fluttertoast.showToast(
                      msg: "ส่งคำขอสำเร็จ",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      DashboardScreen.routeName,
                      (route) => false,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: "ส่งคำขอไม่สำเร็จ",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return BaseDialog(
                        message: 'กรุณาเข้าสู่ระบบก่อนการใช้งาน',
                        hasCancel: true,
                        onClick: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            SignInScreen.routeName,
                            (route) => false,
                          );
                        },
                      );
                    },
                  );
                }
              },
              text: checkRequestChatWaiting
                  ? 'ท่านได้ส่งคำขอไปแล้วกรุณารออนุมัติ'
                  : (checkRequestChatAlready ? 'สนทนา' : 'ส่งคำขอสนทนา'),
            ),
          ] else ...[
            BaseButton(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(EditPharmacyStoreScreen.routeName);
              },
              text: 'แก้ไขข้อมูลร้าน',
            ),
          ],
        ],
      ),
    );
  }
}
