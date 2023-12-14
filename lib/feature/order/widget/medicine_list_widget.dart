import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/feature/order/widget/medicine_item_widget.dart';

class MedicineListWidget extends ConsumerWidget {
  const MedicineListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return const MedicineItemWidget(
          imgUrl:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRIheWe6g2wcEYaGwFoLUr7LITBWCDVPnuCA&usqp=CAU',
          name: 'Vitamin c Capsule',
          quantity: 'จำนวน 1',
          price: '12.10 บาท',
        );
      },
      separatorBuilder: (_, __) => SizedBox(
        height: 16.h,
      ),
    );
  }
}
