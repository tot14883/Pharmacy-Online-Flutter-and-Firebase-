import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/page/add_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/widget/medicine_warehouse_list_widget.dart';

// คลาส CentralMedicineWarehouseScreen สร้างหน้าจอสำหรับแสดงรายการยาในคลังยากลาง
class CentralMedicineWarehouseScreen extends ConsumerStatefulWidget {
  // route name สำหรับนำทางมายังหน้าจอนี้
  static const routeName = 'CentralMedicineWarehouseScreen';

  // Constructor ของคลาส
  const CentralMedicineWarehouseScreen({super.key});

  @override
  _CentralMedicineWarehouseScreenState createState() =>
      _CentralMedicineWarehouseScreenState();
}

// State ของหน้าจอ CentralMedicineWarehouseScreen
class _CentralMedicineWarehouseScreenState
    extends BaseConsumerState<CentralMedicineWarehouseScreen> {
  @override
  Widget build(BuildContext context) {
    // ตรวจสอบว่าผู้ใช้เป็นแอดมินหรือไม่
    final isAdmin = ref
            .read(baseSharePreferenceProvider)
            .getString(BaseSharePreferenceKey.role) ==
        AuthenticationType.admin.name;

    // อ่านข้อมูลรายการยาในคลังยากลางจาก riverpod
    final centralMedicineList = ref.watch(
      storeControllerProvider.select((value) => value.centralMedicineList),
    );

    final searchCentralMedicineList = ref.watch(
      storeControllerProvider
          .select((value) => value.searchCentralMedicineList),
    );

    // จัดการการแสดงผลข้อมูลตามสถานะการโหลดข้อมูล
    return AsyncValueWidget(
      value: centralMedicineList,
      data: (_centralMedicineList) {
        return BaseScaffold(
          appBar: BaseAppBar(
            elevation: 0,
            title: Text(
              'คลังยากลาง',
              style: AppStyle.txtHeader3,
            ),
            // ซ่อนปุ่ม back หากผู้ใช้เป็นแอดมิน
            hideBackButton: isAdmin,
            // ปุ่มเพิ่มยาหากผู้ใช้เป็นแอดมิน
            actions: isAdmin
                ? [
                    GestureDetector(
                      onTap: () {
                        // นำทางไปหน้าจอเพิ่มยา
                        Navigator.of(context).pushNamed(
                          AddMedicineWarehouseScreen.routeName,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8).r,
                        child: Text(
                          'เพิ่มยา',
                          style: AppStyle.txtBody,
                        ),
                      ),
                    )
                  ]
                : null,
            bgColor: AppColor.themeWhiteColor,
          ),
          bgColor: AppColor.themeWhiteColor,
          bodyBuilder: (context, constrained) {
            // หากข้อมูลรายการยายังไม่พร้อม ให้แสดง SizedBox.shrink()
            if (_centralMedicineList == null) {
              return const SizedBox.shrink();
            }

            // ถ้าข้อมูลพร้อม ให้แสดงรายการยา
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 72).r,
              child: Column(
                children: [
                  BaseTextField(
                    placeholder: 'ค้นหายา',
                    onChange: (val) {
                      ref
                          .read(storeControllerProvider.notifier)
                          .onSearchMedicine(val);
                    },
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  MedicineWarehouseListWidget(
                    onTap: (val) {},
                    // onTap: (val) {}, // ฟังก์ชันเมื่อกดรายการยา (ยังไม่ถูกใช้งาน)
                    medicineList:
                        searchCentralMedicineList ?? _centralMedicineList,
                    isCentral: true, // ระบุว่าเป็นคลังยากลาง
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
