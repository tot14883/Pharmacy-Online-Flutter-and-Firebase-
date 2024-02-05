import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/feature/order/widget/medicine_item_widget.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class MedicineListWidget extends ConsumerWidget {
  final bool hasTextForm; // กำหนดว่าต้องการแสดงช่องกรอกข้อความหรือไม่
  final List<MedicineResponse> medicineList; // ข้อมูลรายชื่อยา
  final Function(Map<String, String> text)
      onChange; //จัดการการเปลี่ยนแปลงในช่องกรอกข้อความ

  const MedicineListWidget({
    super.key,
    this.hasTextForm = false,
    required this.medicineList,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      // สร้าง ListView สำหรับแสดงข้อมูลยา
      physics: const NeverScrollableScrollPhysics(), // ปิดการเลื่อนอิสระ
      shrinkWrap: true, // ให้ ListView ปรับขนาดตามเนื้อหา
      itemCount: medicineList.length, // จำนวนรายการข้อมูลยา
      itemBuilder: (context, index) {
        // ฟังก์ชั่นสำหรับสร้างแต่ละรายการยา
        final medicineItem = medicineList[index]; // ข้อมูลยาชิ้นที่ index

        return Column(
          // จัดเรียงข้อมูลยาในแนวตั้ง
          children: [
            GestureDetector(
              onTap: () {},
              child: MedicineItemWidget(
                // แสดงข้อมูลยา เช่น รูปภาพ ชื่อ จำนวน ราคา
                imgUrl: '${medicineItem.medicineImg}',
                name: '${medicineItem.name}',
                quantity: 'จำนวน ${medicineItem.quantity}',
                price:
                    '${(medicineItem.price ?? 0.0) * (medicineItem.quantity ?? 1)} บาท',
                band: '${medicineItem.band}',
                medicineType: '${medicineItem.medicineType}',
              ),
            ),
            if (hasTextForm) ...[
              // แสดงช่องกรอกข้อความถ้า hasTextForm เป็น true
              SizedBox(
                height: 8.h,
              ),
              BaseTextField(
                // ช่องกรอกข้อความสำหรับคำแนะนำการใช้ยา
                label: 'วิธีการใช้/คำแนะนำ',
                isShowLabelField: false,
                validator: Validators.combine(
                  // ตรวจสอบข้อมูลกรอก
                  [
                    Validators.withMessage(
                      "Required",
                      Validators.isEmpty,
                    ),
                  ],
                ),
                onChange: (val) {
                  // เรียกใช้ฟังก์ชั่นเมื่อข้อมูลในช่องกรอกเปลี่ยนแปลง
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
