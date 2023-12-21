import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/page/add_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/page/central_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/widget/medicine_warehouse_list_widget.dart';

class MyMedicineWarehouseScreen extends ConsumerStatefulWidget {
  static const routeName = 'MyMedicineWarehouseScreen';

  const MyMedicineWarehouseScreen({super.key});

  @override
  _MyMedicineWarehouseScreenState createState() =>
      _MyMedicineWarehouseScreenState();
}

class _MyMedicineWarehouseScreenState
    extends BaseConsumerState<MyMedicineWarehouseScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          'คลังยาร้าน',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themeWhiteColor,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(CentralMedicineWarehouseScreen.routeName);
            },
            child: Padding(
              padding: const EdgeInsets.all(16).r,
              child: Text(
                'เพิ่มจากคลังยากลาง',
                style: AppStyle.txtBody2,
              ),
            ),
          ),
        ],
      ),
      bgColor: AppColor.themeWhiteColor,
      bodyBuilder: (context, constrained) {
        final medicineList = ref.watch(
            storeControllerProvider.select((value) => value.medicineList));

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              AsyncValueWidget(
                value: medicineList,
                data: (_medicineList) {
                  if (_medicineList == null) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      MediaQuery.of(context).padding.bottom,
                    ).r,
                    child: MedicineWarehouseListWidget(
                      medicineList: _medicineList,
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(16).r,
                  color: AppColor.themeWhiteColor,
                  child: BaseButton(
                    width: 60.w,
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AddMedicineWarehouseScreen.routeName);
                    },
                    text: 'เพิ่มยา',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
