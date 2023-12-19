import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/order/widget/card_content_widget.dart';
import 'package:pharmacy_online/feature/order/widget/medicine_list_widget.dart';
import 'package:pharmacy_online/feature/order/widget/row_content_widget.dart';

class OrderSummaryScreen extends ConsumerStatefulWidget {
  static const routeName = 'OrderSummaryScreen';

  const OrderSummaryScreen({super.key});

  @override
  _OrderSummaryScreenState createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends BaseConsumerState<OrderSummaryScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          'คำสั่งซื้อ',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themLineColor,
      ),
      bgColor: AppColor.themLineColor,
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
                const BaseTextField(
                  label: 'วินิจฉัยอาการป่วย',
                ),
                SizedBox(
                  height: 16.h,
                ),
                const BaseTextField(
                  label: 'รายละเอียดเพิ่มเติม',
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
                  child: const MedicineListWidget(hasTextForm: true),
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseButton(
                  onTap: () {},
                  text: 'ถัดไป',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
