import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_switch_button.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/page/search_result_pharmacy_store_screen.dart';
import 'package:pharmacy_online/feature/store/widget/filter_distance_widget.dart';

class FilterWidget extends ConsumerStatefulWidget {
  const FilterWidget({super.key});

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends BaseConsumerState<FilterWidget> {
  // สร้าง controller สำหรับจัดการค่าของค้นหาชื่อร้าน
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    // ทำลาย nameController เมื่อหน้านี้ปิด เพื่อไม่ให้เปลือง memomry
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ดึงค่า search distance ที่ได้ทำการค้นหาไปเพื่อทำเป็น initial value
    final distance = ref
        .watch(storeControllerProvider.select((value) => value.searchDistance));
    // ดึงค่า search review score ที่ได้ทำการค้นหาไปเพื่อทำเป็น initial value
    final reviewScore = ref.watch(
        storeControllerProvider.select((value) => value.searchReviewScore));
    // ดึงค่า search count reviewer ที่ได้ทำการค้นหาไปเพื่อทำเป็น initial value
    final countReviewer = ref.watch(
        storeControllerProvider.select((value) => value.searchCountReviewer));
    // ดึงค่า search opening time ที่ได้ทำการค้นหาไปเพื่อทำเป็น initial value
    final opeingTime = ref.watch(
        storeControllerProvider.select((value) => value.searchOpeningTime));
    // ดึงค่า search closing time ที่ได้ทำการค้นหาไปเพื่อทำเป็น initial value
    final closingTime = ref.watch(
        storeControllerProvider.select((value) => value.searchClosingTime));

    return Container(
      // ทำการ re-render หน้านี้ทุกครั้งเมื่อมีการเปลี่ยนแปลงค่า
      key: ValueKey((distance ??
              reviewScore ??
              countReviewer ??
              opeingTime ??
              closingTime)
          .hashCode),
      color: AppColor.themeWhiteColor,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // input ค้นหาร้านยา
          BaseTextField(
            label: 'ค้นหาร้านยา',
            isShowLabelField: true,
            onChange: (val) {
              nameController.text = val;
            },
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            'ระยะทาง (กิโลเมตร)',
            style: AppStyle.txtBody2,
          ),
          // Filter distance
          FilterDistanceWidget(
            initial: distance,
            onUpdate: (val) {
              // ทุกครั้งที่ update value ให้ทำการเก็บค่าใน onSetSearchDistance
              ref
                  .read(storeControllerProvider.notifier)
                  .onSetSearchDistance(val);
            },
          ),
          SizedBox(
            height: 8.h,
          ),
          // BaseSwitchButton คล้ายหน้า sign up screen
          BaseSwitchButton(
            isSwitchButton: true,
            label: "คะแนนรีวิว (ขึ้นไป)",
            minWidth: 100.w,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
            ).w,
            initialValue: [
              SwitchButtonItem(
                id: reviewScore?.id ?? 0,
                value: '${reviewScore?.value}',
                content: '${reviewScore?.content}',
              ),
            ],
            listItem: const [
              SwitchButtonItem(
                id: 1,
                value: '1',
                content: "1 ดาว",
              ),
              SwitchButtonItem(
                id: 2,
                value: '2',
                content: "2 ดาว",
              ),
              SwitchButtonItem(
                id: 3,
                value: '3',
                content: "3 ดาว",
              ),
              SwitchButtonItem(
                id: 4,
                value: '4',
                content: "4 ดาว",
              ),
              SwitchButtonItem(
                id: 5,
                value: '5',
                content: "5 ดาว",
              ),
            ],
            onChange: (val) {
              ref
                  .read(storeControllerProvider.notifier)
                  .onSetSearchRaiting(val);
            },
          ),
          SizedBox(
            height: 8.h,
          ),
          // BaseSwitchButton คล้ายหน้า sign up screen
          BaseSwitchButton(
            isSwitchButton: true,
            label: "จำนวนคนรีวิว (ขึ้นไป)​",
            minWidth: 100.w,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
            ).w,
            initialValue: [
              SwitchButtonItem(
                id: countReviewer?.id ?? 0,
                value: '${countReviewer?.value}',
                content: '${countReviewer?.content}',
              ),
            ],
            listItem: const [
              SwitchButtonItem(
                id: 1,
                value: '10',
                content: "10 คน",
              ),
              SwitchButtonItem(
                id: 2,
                value: '20',
                content: "20 คน",
              ),
              SwitchButtonItem(
                id: 3,
                value: '30',
                content: "30 คน",
              ),
              SwitchButtonItem(
                id: 4,
                value: '40',
                content: "40 คน",
              ),
              SwitchButtonItem(
                id: 5,
                value: '50',
                content: "50 คน",
              ),
            ],
            onChange: (val) {
              ref
                  .read(storeControllerProvider.notifier)
                  .onSetSearchCountReviewer(val);
            },
          ),
          SizedBox(
            height: 8.h,
          ),
          // ปุุ่มค้นหา
          BaseButton(
            onTap: () async {
              // เคลียร์ข้อมูลเพื่อร้านข้อมูลเก่าใน search ทิ้ง
              ref
                  .read(storeControllerProvider.notifier)
                  .onClearSelectedPharmacyStore();

              // เริ่มการค้นหาข้อมูล
              // nameController ไม่สามารถทำแบบการค้นหาอื่นๆได้ เนื่องจาก nameController จำเป็นต้องใช้ในหน้า Stateful เท่านั้นห
              ref
                  .read(storeControllerProvider.notifier)
                  .onSearchPharmacyStore(name: nameController.text);

              // ดึงร้านค่าที่ค้นหาเจอ
              final searchPharmacyInfoList = ref.watch(
                storeControllerProvider.select(
                  (value) => value.searchPharmacyInfoList,
                ),
              );

              // ตรวจสอบว่าค้นหาร้านค้าเจอ
              if (searchPharmacyInfoList != null &&
                  searchPharmacyInfoList.isNotEmpty) {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  SearchResultPharmacyStoreScreen.routeName,
                );
              } else {
                // ถ้าไม่เจอก็ทำ error message มา แสดง
                final result = ref.read(
                  storeControllerProvider.select(
                    (value) => value.searchError,
                  ),
                );

                Fluttertoast.showToast(
                  msg: result ?? "ไม่พบเจอร้านเภสัช",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );

                ref.read(storeControllerProvider.notifier).onClearError();
              }
            },
            text: 'ค้นหา',
          ),
          SizedBox(
            height: 8.h,
          ),
          // ค้นหาทุกร้าน
          BaseButton(
            buttonType: ButtonType.secondary,
            onTap: () async {
              ref
                  .read(storeControllerProvider.notifier)
                  .onClearSelectedPharmacyStore();
              ref
                  .read(storeControllerProvider.notifier)
                  .onSearchPharmacyStore(isAll: true);

              final searchPharmacyInfoList = ref.watch(
                storeControllerProvider.select(
                  (value) => value.searchPharmacyInfoList,
                ),
              );

              if (searchPharmacyInfoList != null &&
                  searchPharmacyInfoList.isNotEmpty) {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  SearchResultPharmacyStoreScreen.routeName,
                );
              } else {
                final result = ref.read(
                  storeControllerProvider.select(
                    (value) => value.searchError,
                  ),
                );

                Fluttertoast.showToast(
                  msg: result ?? "ไม่พบเจอร้านเภสัช",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );

                ref.read(storeControllerProvider.notifier).onClearError();
              }
            },
            text: 'ค้นหาทุกร้าน',
          ),
          SizedBox(
            height: 8.h,
          ),
          BaseButton(
            buttonType: ButtonType.tertiary,
            onTap: () async {
              ref.read(storeControllerProvider.notifier).onClearSearch();
            },
            text: 'ล้างการค้นหา',
          ),
        ],
      ),
    );
  }
}
