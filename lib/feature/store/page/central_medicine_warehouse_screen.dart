import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/page/add_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/widget/medicine_warehouse_list_widget.dart';

class CentralMedicineWarehouseScreen extends ConsumerStatefulWidget {
  static const routeName = 'CentralMedicineWarehouseScreen';

  const CentralMedicineWarehouseScreen({super.key});

  @override
  _CentralMedicineWarehouseScreenState createState() =>
      _CentralMedicineWarehouseScreenState();
}

class _CentralMedicineWarehouseScreenState
    extends BaseConsumerState<CentralMedicineWarehouseScreen> {
  @override
  Widget build(BuildContext context) {
    final isAdmin = ref
            .read(baseSharePreferenceProvider)
            .getString(BaseSharePreferenceKey.role) ==
        AuthenticationType.admin.name;

    final centralMedicineList = ref.watch(
        storeControllerProvider.select((value) => value.centralMedicineList));

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
            hideBackButton: isAdmin,
            actions: isAdmin
                ? [
                    GestureDetector(
                      onTap: () {
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
            if (_centralMedicineList == null) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 72).r,
              child: MedicineWarehouseListWidget(
                onTap: (val) {},
                medicineList: _centralMedicineList,
                isCentral: true,
              ),
            );
          },
        );
      },
    );
  }
}
