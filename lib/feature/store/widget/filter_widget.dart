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
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final distance = ref
        .watch(storeControllerProvider.select((value) => value.searchDistance));
    final reviewScore = ref.watch(
        storeControllerProvider.select((value) => value.searchReviewScore));
    final countReviewer = ref.watch(
        storeControllerProvider.select((value) => value.searchCountReviewer));
    final opeingTime = ref.watch(
        storeControllerProvider.select((value) => value.searchOpeningTime));
    final closingTime = ref.watch(
        storeControllerProvider.select((value) => value.searchClosingTime));

    return Container(
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
          FilterDistanceWidget(
            initial: distance,
            onUpdate: (val) {
              ref
                  .read(storeControllerProvider.notifier)
                  .onSetSearchDistance(val);
            },
          ),
          SizedBox(
            height: 8.h,
          ),
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
          // Text(
          //   'เวลาเปิด-ปิด',
          //   style: AppStyle.txtBody2,
          // ),
          // SizedBox(
          //   height: 8.h,
          // ),
          // FilterTimeCloseOpenWidget(
          //   initialOpen: opeingTime,
          //   initialClose: closingTime,
          //   onUpdateOpen: (open) {
          //     ref
          //         .read(storeControllerProvider.notifier)
          //         .onSetSearchOpeningTime(open);
          //   },
          //   onUpdateClose: (close) {
          //     ref
          //         .read(storeControllerProvider.notifier)
          //         .onSetSearchClosingTime(close);
          //   },
          // ),
          // SizedBox(
          //   height: 8.h,
          // ),
          BaseButton(
            onTap: () async {
              ref
                  .read(storeControllerProvider.notifier)
                  .onClearSelectedPharmacyStore();
              ref
                  .read(storeControllerProvider.notifier)
                  .onSearchPharmacyStore(name: nameController.text);

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
            text: 'ค้นหา',
          ),
          SizedBox(
            height: 8.h,
          ),
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
