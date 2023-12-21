import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';
import 'package:pharmacy_online/feature/store/page/drug_detail_screen.dart';
import 'package:pharmacy_online/feature/store/page/edit_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class MedicineWarehouseItemWidget extends ConsumerWidget {
  final MedicineResponse medicineItem;
  final bool isCentral;

  const MedicineWarehouseItemWidget({
    super.key,
    required this.medicineItem,
    required this.isCentral,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = medicineItem.uid;
    final _uid = ref
        .read(baseSharePreferenceProvider)
        .getString(BaseSharePreferenceKey.userId);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(DrugDetailScreen.routeName);
          },
          child: BaseImageView(
            url: '${medicineItem.medicineImg}',
            width: 80.w,
            height: 80.h,
          ),
        ),
        SizedBox(
          width: 16.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(DrugDetailScreen.routeName);
                      },
                      child: Text(
                        '${medicineItem.name}',
                        style: AppStyle.txtBody,
                      ),
                    ),
                  ),
                  if (isCentral && uid != _uid) ...[
                    BaseButton(
                      width: 50.w,
                      onTap: () {},
                      iconWidget: Padding(
                        padding: const EdgeInsets.only(top: 4).h,
                        child: Assets.icons.icPlus.svg(),
                      ),
                    ),
                  ],
                  if (uid == _uid) ...[
                    SizedBox(
                      width: 8.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          EditMedicineWarehouseScreen.routeName,
                          arguments: MedicineWarehouseArgs(
                            medicineItem: medicineItem,
                          ),
                        );
                      },
                      child: Assets.icons.icEdit.svg(
                        width: 32.w,
                        height: 32.h,
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final isConfirm = await showDialog<bool>(
                          context: context,
                          builder: (_) {
                            return BaseDialog(
                              message: 'ต้องการลบรายการนี้หรือไม่',
                              hasCancel: true,
                            );
                          },
                        );

                        if (isConfirm != null && isConfirm) {
                          final result = await ref
                              .read(storeControllerProvider.notifier)
                              .deleteMedicineWarehouse(medicineItem.id);

                          if (result) {
                            await ref
                                .read(storeControllerProvider.notifier)
                                .onGetCentralMedicineWarehouse();
                          }
                        }
                      },
                      child:
                          Assets.icons.icDelete.svg(width: 48.w, height: 48.h),
                    ),
                  ],
                ],
              ),
              if (!isCentral) ...[
                SizedBox(
                  height: 16.h,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(DrugDetailScreen.routeName);
                  },
                  child: Text(
                    '${medicineItem.price} ราคา',
                    style: AppStyle.txtBody,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
