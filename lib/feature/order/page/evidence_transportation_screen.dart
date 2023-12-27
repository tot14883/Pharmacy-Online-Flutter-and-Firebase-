import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/order/controller/order_controller.dart';

class EvidenceTransportationScreen extends ConsumerStatefulWidget {
  static const routeName = 'EvidenceTransportationScreen';

  const EvidenceTransportationScreen({super.key});

  @override
  _EvidenceTransportationScreenState createState() =>
      _EvidenceTransportationScreenState();
}

class _EvidenceTransportationScreenState
    extends BaseConsumerState<EvidenceTransportationScreen> {
  XFile? evidenceFile;

  @override
  Widget build(BuildContext context) {
    final orderDetail = ref
        .watch(orderControllerProvider.select((value) => value.orderDetail))
        .value;

    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        title: Text(
          'จัดส่งสินค้า',
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
                BaseImageView(
                  url: '${orderDetail?.deliverySlip}',
                  width: 350.w,
                  height: 350.h,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  'หลักฐานการจัดส่งสินค้า',
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
