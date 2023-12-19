import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_divider.dart';
import 'package:pharmacy_online/feature/store/widget/medicine_warehouse_item_widget.dart';

class MedicineWarehouseListWidget extends ConsumerWidget {
  final bool isCentral;

  const MedicineWarehouseListWidget({
    super.key,
    this.isCentral = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return MedicineWarehouseItemWidget(
          imgUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRIheWe6g2wcEYaGwFoLUr7LITBWCDVPnuCA&usqp=CAU',
          name: 'Vitamin c Capsule',
          price: '12.10 บาท',
          isCentral: isCentral,
        );
      },
      separatorBuilder: (_, __) => const BaseDivider(),
    );
  }
}
