import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
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
    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          'คลังยากลาง',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themeWhiteColor,
      ),
      bgColor: AppColor.themeWhiteColor,
      bodyBuilder: (context, constrained) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 72).r,
          child: const MedicineWarehouseListWidget(
            isCentral: true,
          ),
        );
      },
    );
  }
}
