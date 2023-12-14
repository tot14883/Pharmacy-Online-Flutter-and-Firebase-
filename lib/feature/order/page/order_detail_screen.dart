import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/order/page/add_review_screen.dart';
import 'package:pharmacy_online/feature/order/page/evidence_transportation_screen.dart';
import 'package:pharmacy_online/feature/order/page/upload_bank_transfer_screen.dart';
import 'package:pharmacy_online/feature/order/widget/card_content_widget.dart';
import 'package:pharmacy_online/feature/order/widget/medicine_list_widget.dart';
import 'package:pharmacy_online/feature/order/widget/row_content_widget.dart';
import 'package:pharmacy_online/feature/order/widget/tracking_content_widget.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  static const routeName = 'OrderDetailScreen';

  const OrderDetailScreen({super.key});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends BaseConsumerState<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      bgColor: AppColor.themLineColor,
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          'คำสั่งซื้อ',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themLineColor,
      ),
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CardContentWidget(
                  content: Column(
                    children: [
                      const RowContentWidget(
                        header: 'ร้าน:',
                        content: 'เพื่อนเภสัช',
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      const RowContentWidget(
                        header: 'เลขที่บิล:',
                        content: '465468753413654',
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      const RowContentWidget(
                        header: 'วันที่:',
                        content: '20/11/2023',
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      const RowContentWidget(
                        header: 'เวลา:',
                        content: '16.30',
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      const RowContentWidget(
                        header: 'ราคารวมทั้งหมด:',
                        content: '73.99',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                CardContentWidget(
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ธีรวัฒน์ รัตนโภคา',
                        style: AppStyle.txtBody,
                      ),
                      Text(
                        '081-234-5678',
                        style: AppStyle.txtBody,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        '33 ตำบลตลาดขวัญ อำเภอเมืองนนทบุรี จังหวัดนนทบุร',
                        style: AppStyle.txtCaption.copyWith(
                          color: AppColor.themeGrayLight,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  'รายละเอียดสินค้า',
                  style: AppStyle.txtHeader3,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Container(
                  padding: const EdgeInsets.all(16).r,
                  color: AppColor.themeWhiteColor,
                  child: const MedicineListWidget(),
                ),
                SizedBox(
                  height: 16.h,
                ),
                CardContentWidget(
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'วินิจฉัยอาการป่วย',
                        style: AppStyle.txtBody
                            .copyWith(color: AppColor.themePrimaryColor),
                      ),
                      Text(
                        '    เป็นไข้หวัดที่เกิดจากการตากฝน',
                        style: AppStyle.txtBody,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        'รายละเอียดเพิ่มเติม',
                        style: AppStyle.txtBody
                            .copyWith(color: AppColor.themePrimaryColor),
                      ),
                      Text(
                        '    ไม่ระบุ',
                        style: AppStyle.txtBody,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        'รายละเอียดเพิ่มเติม',
                        style: AppStyle.txtBody
                            .copyWith(color: AppColor.themePrimaryColor),
                      ),
                      const RowContentWidget(
                        isBold: true,
                        header: 'ชื่อยา',
                        content: 'วิธีการใช้/คำแนะนำ',
                      ),
                      const RowContentWidget(
                        isBold: true,
                        header: 'ยาแก้ไอ',
                        content: 'ทานหลังอาหาร 3 ครั้ง เช้า / กลางวัน /ก่อนนอน',
                      ),
                      const RowContentWidget(
                        isBold: true,
                        header: 'ยาแก้ปวด',
                        content: 'ทานหลังอาหารเมื่อมีอาการปวด',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  'ติดตามสินค้า',
                  style: AppStyle.txtHeader3,
                ),
                SizedBox(
                  height: 16.h,
                ),
                TrackingContentWidget(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      UploadBankTransferScreen.routeName,
                    );
                  },
                  number: '1',
                  title: 'การชำระเงิน',
                  content: 'กรุณาชำระเงิน',
                  btnTxt: 'สแกน QR Code',
                ),
                const TrackingContentWidget(
                  hasBtn: false,
                  number: '2',
                  title: 'รอดำเนินการ',
                  content: 'เภสัชกำลังตรวจสอบการชำระเงิน',
                  contentHeight: 60.0,
                ),
                TrackingContentWidget(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(EvidenceTransportationScreen.routeName);
                  },
                  number: '3',
                  title: 'กำลังจัดส่งสินค้า',
                  content: 'เภสัชกำลังเตรียมจัดส่งสินค้า',
                  btnTxt: 'ดูรูปภาพ',
                ),
                TrackingContentWidget(
                  isSecondBtn: false,
                  onTap: () {
                    Navigator.of(context).pushNamed(AddReviewScreen.routeName);
                  },
                  number: '4',
                  title: 'สินค้าส่งถึงแล้ว',
                  btnTxt: 'ยืนยัน',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
