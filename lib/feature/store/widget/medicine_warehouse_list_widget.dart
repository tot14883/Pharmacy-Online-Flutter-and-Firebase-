import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_divider.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';
import 'package:pharmacy_online/feature/store/widget/medicine_warehouse_item_widget.dart';

class MedicineWarehouseListWidget extends ConsumerWidget {
  final bool isCentral;
  final List<MedicineResponse> medicineList;

  const MedicineWarehouseListWidget({
    super.key,
    this.isCentral = false,
    required this.medicineList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: medicineList.length,
      itemBuilder: (context, index) {
        final medicineItem = medicineList[index];

        return MedicineWarehouseItemWidget(
          medicineItem: medicineItem,
          isCentral: isCentral,
        );
      },
      separatorBuilder: (_, __) => const BaseDivider(),
    );
  }
}
