import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';

class EvidenceBankTransferScreen extends ConsumerWidget {
  static const routeName = 'EvidenceBankTransferScreen';

  const EvidenceBankTransferScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        title: Text(
          'แจ้งโอนการชำระเงิน',
          style: AppStyle.txtHeader3,
        ),
        elevation: 0,
      ),
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BaseImageView(
                  url:
                      'https://cdn.printshoppy.com/image/cache/catalog/product-image/stationery/bill-book/bill-book-102-600x800.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  'หลักฐานแจ้งโอนการชำระเงิน',
                  style: AppStyle.txtHeader3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
