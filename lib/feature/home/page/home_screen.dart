import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';
// import 'package:pharmacy_online/feature/chat/controller/chat_controller.dart';
// import 'package:pharmacy_online/feature/chat/page/inbox_screen.dart';
import 'package:pharmacy_online/feature/chat/page/request_consult_screen.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/home/widget/menu_buttton_widget.dart';
import 'package:pharmacy_online/feature/home/widget/user_profile_header_widget.dart';
// import 'package:pharmacy_online/feature/order/controller/order_controller.dart';
// import 'package:pharmacy_online/feature/order/page/orders_screen.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/page/my_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/page/near_pharmacy_store_screen.dart';
import 'package:pharmacy_online/feature/store/page/store_detail_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/date_format.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = 'HomeScreen';

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseConsumerState<HomeScreen> {
  double? nearestDistance;
  double myLatitude = 0.0;
  double myLongtitude = 0.0;
  Timer? timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final _myLatitude = ref.watch(
        storeControllerProvider.select((value) => value.myLatitude),
      );
      final _myLongtitude = ref.watch(
        storeControllerProvider.select((value) => value.myLongtitude),
      );

      myLatitude = _myLatitude ?? 0.0;
      myLongtitude = _myLongtitude ?? 0.0;
    });
    super.initState();

    timer = timer =
        Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      await ref.read(homeControllerProvider.notifier).onGetNotification();
      await ref.read(storeControllerProvider.notifier).getPharmacyInfo();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // ฟังก์ชันสำหรับคำนวณ Marker ที่ใกล้ที่สุด
  void findNearestMarker({
    required List<PharmacyInfoResponse> pharmacyInfoList,
  }) async {
    double minDistance = double.infinity;
    PharmacyInfoResponse? pharmacyNearest;

    final _pharmacyInfoList = pharmacyInfoList.where((val) {
      final currentTime = DateTime.now();
      final timeClosing =
          ref.read(baseDateFormatterProvider).convertTimeStringToDateTime(
                val.timeClosing ?? '${currentTime.hour}:${currentTime.minute}',
              );
      final timeOpening =
          ref.read(baseDateFormatterProvider).convertTimeStringToDateTime(
                val.timeOpening ?? '${currentTime.hour}:${currentTime.minute}',
              );
      return currentTime.isAfter(timeOpening) &&
          currentTime.isBefore(timeClosing);
    }).toList();

    for (final pharmacyItem in _pharmacyInfoList) {
      double distance = Geolocator.distanceBetween(
        myLatitude,
        myLongtitude,
        pharmacyItem.latitude ?? 0.0,
        pharmacyItem.longtitude ?? 0.0,
      );

      if (distance < minDistance) {
        minDistance = distance;
        pharmacyNearest = pharmacyItem;
      }
    }

    final nearPharmacyStore = pharmacyInfoList
        .where((val) => val.uid == pharmacyNearest?.uid)
        .toList();

    if (nearPharmacyStore.isNotEmpty) {
      Navigator.of(context).pushNamed(
        StoreDetailScreen.routeName,
        arguments:
            StoreDetailArgs(pharmacyInfoResponse: nearPharmacyStore.first),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPharmacy = ref
        .watch(profileControllerProvider.select((value) => value.isPharmacy));
    final pharmacyInfoList = ref.watch(
      storeControllerProvider.select((value) => value.pharmacyInfoList),
    );

    final hasUserInfo = ref
            .watch(
              profileControllerProvider.select((value) => value.userInfo),
            )
            ?.uid !=
        null;

    final notificationList = ref.watch(
      homeControllerProvider.select((value) => value.notificationList),
    );

    return BaseScaffold(
      bodyBuilder: (context, constraints) {
        return AsyncValueWidget(
          value: notificationList,
          data: (_notificationList) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const UserProfileHeaderWidget(),
                  SizedBox(
                    height: 24.h,
                  ),
                  Assets.imgs.imgPharmacyStore.image(),
                  SizedBox(
                    height: 16.h,
                  ),
                  Wrap(
                    spacing: 16.0,
                    runSpacing: 16.0,
                    children: [
                      if (!isPharmacy) ...[
                        //ส่วนของ user
                        MenuButtonWidget(
                          onTap: () {
                            findNearestMarker(
                              pharmacyInfoList: pharmacyInfoList.value ?? [],
                            );
                          },
                          imgWidget: Assets.icons.icRefresh.svg(),
                          label: 'ค้นหาอัตโนมัติ',
                        ),
                        MenuButtonWidget(
                          onTap: () async {
                            await ref
                                .read(storeControllerProvider.notifier)
                                .getPharmacyInfo();

                            Navigator.of(context)
                                .pushNamed(NearPharmacyStoreScreen.routeName);
                          },
                          isSecondBtn: true,
                          imgWidget: Assets.icons.icLocationPin.svg(),
                          label: 'ค้นหาร้านยา',
                        ),
                        if (hasUserInfo) ...[],
                      ],
                      if (isPharmacy) ...[
                        //ส่วนของ isPharmacy
                        MenuButtonWidget(
                          onTap: () async {
                            await ref
                                .read(storeControllerProvider.notifier)
                                .onGetGetRequestChatWithPharmacy();

                            Navigator.of(context)
                                .pushNamed(RequestConsultScreen.routeName);
                          },
                          imgWidget: Assets.icons.icChatMarkUnread.svg(),
                          label: 'การขอรับการปรึกษา',
                        ),
                        MenuButtonWidget(
                          onTap: () {
                            ref
                                .read(storeControllerProvider.notifier)
                                .onGetCentralMedicineWarehouse();
                            ref
                                .read(storeControllerProvider.notifier)
                                .onGetMedicineWarehouse();

                            Navigator.of(context).pushNamed(
                              MyMedicineWarehouseScreen.routeName,
                              arguments: MyMedicineWarehouseArgs(
                                isFromChat: false,
                              ),
                            );
                          },
                          isSecondBtn: true,
                          imgWidget: Assets.imgs.imgShop.image(),
                          label: 'คลังยา',
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
