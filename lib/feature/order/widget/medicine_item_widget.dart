import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';
import 'package:pharmacy_online/feature/store/page/drug_detail_screen.dart';

class MedicineItemWidget extends StatelessWidget {
  // ประกาศตัวแปรสำหรับเก็บข้อมูลของยา
  final String imgUrl;
  final String name;
  final String? caption; // caption อาจเป็น null ได้
  final String quantity;
  final String price;
  final String size;
  final String material;
  final bool isOrder;
  final String purePrice;

  // constructor รับค่าตัวแปรต่างๆ
  const MedicineItemWidget({
    super.key,
    required this.imgUrl,
    required this.name,
    this.caption,
    required this.quantity,
    required this.price,
    required this.size,
    required this.material,
    this.isOrder = false,
    required this.purePrice,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final quantityParsed = quantity.split('จำนวน ');

        Navigator.of(context).pushNamed<bool>(
          DrugDetailScreen.routeName,
          arguments: DrugDetailArgs(
            medicineItem: MedicineResponse(
              medicineImg: imgUrl,
              name: name,
              price: double.parse(purePrice),
              quantity: int.parse(quantityParsed[1]),
              size: size,
              material: material,
            ),
            isOnlyDetail: true,
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // ชิดบน
        mainAxisAlignment: MainAxisAlignment.start, // ชิดซ้าย
        children: [
          // รูปภาพยา
          BaseImageView(
            url: imgUrl,
            width: 80.w,
            height: 80.h,
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 16.w,
          ),
          Expanded(
            // ให้ข้อมูลยาขยายเต็มพื้นที่ที่เหลือ
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // ชิดบน
              mainAxisAlignment: MainAxisAlignment.start, // ชิดซ้าย
              children: [
                // ชื่อยา
                Text(
                  name,
                  style: AppStyle.txtBody,
                ),
                Text(
                  size,
                  style: AppStyle.txtBody,
                ),
                if (!isOrder) ...[
                  Text(
                    material,
                    style: AppStyle.txtBody,
                    textAlign: TextAlign.end,
                  ),
                ],
                if (caption != null) ...[
                  Text(
                    '$caption',
                    style: AppStyle.txtBody2.copyWith(
                      color: AppColor.themeGrayLight,
                    ),
                  ),
                ],
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // ชิดบน
                  mainAxisAlignment: MainAxisAlignment.start, // ชิดซ้าย
                  children: [
                    Expanded(
                      child: Text(
                        quantity,
                        style: AppStyle.txtBody,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        price,
                        style: AppStyle.txtBody,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
