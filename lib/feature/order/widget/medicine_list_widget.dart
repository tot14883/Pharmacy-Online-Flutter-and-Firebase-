import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/feature/order/widget/medicine_item_widget.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class MedicineListWidget extends ConsumerWidget {
  final bool hasTextForm;
  final List<MedicineResponse> medicineList;
  final Function(Map<String, String> text) onChange;

  const MedicineListWidget({
    super.key,
    this.hasTextForm = false,
    required this.medicineList,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: medicineList.length,
      itemBuilder: (context, index) {
        final medicineItem = medicineList[index];

        return Column(
          children: [
            MedicineItemWidget(
              imgUrl: '${medicineItem.medicineImg}',
              name: '${medicineItem.name}',
              quantity: 'จำนวน ${medicineItem.quantity}',
              price: '${medicineItem.price} บาท',
            ),
            if (hasTextForm) ...[
              SizedBox(
                height: 8.h,
              ),
              BaseTextField(
                label: 'วิธีการใช้/คำแนะนำ',
                isShowLabelField: false,
                validator: Validators.combine(
                  [
                    Validators.withMessage(
                      "Required",
                      Validators.isEmpty,
                    ),
                  ],
                ),
                onChange: (val) {
                  onChange({'${medicineItem.cartMedicineId}': val});
                },
              ),
            ],
          ],
        );
      },
      separatorBuilder: (_, __) => SizedBox(
        height: 16.h,
      ),
    );
  }
}
