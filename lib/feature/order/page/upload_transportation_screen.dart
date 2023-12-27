import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_upload_image_button.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/order/controller/order_controller.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class UploadTransportationScreen extends ConsumerStatefulWidget {
  static const routeName = 'UploadTransportationScreen';

  const UploadTransportationScreen({super.key});

  @override
  _UploadTransportationScreenState createState() =>
      _UploadTransportationScreenState();
}

class _UploadTransportationScreenState
    extends BaseConsumerState<UploadTransportationScreen> {
  XFile? evidenceFile;

  @override
  Widget build(BuildContext context) {
    final orderDetail = ref
        .watch(orderControllerProvider.select((value) => value.orderDetail))
        .value;
    final id = orderDetail?.id;
    final uid = orderDetail?.uid;
    final pharmacyId = orderDetail?.pharmacyId;
    final cartId = orderDetail?.cartId;
    final nameStore = orderDetail?.myCart?.nameStore;
    final deliverySlip = orderDetail?.deliverySlip;
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
                BaseUploadImageButton(
                  imgPreview: deliverySlip != null
                      ? BaseImageView(
                          url: deliverySlip,
                          width: 350.w,
                          height: 350.h,
                          fit: BoxFit.cover,
                        )
                      : Assets.icons.icAddImg.svg(),
                  height: 350.h,
                  width: 350.w,
                  onUpload: (val) {
                    setState(() {
                      evidenceFile = val;
                    });
                  },
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  'หลักฐานการจัดส่งสินค้า',
                  style: AppStyle.txtHeader3,
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseButton(
                  onTap: () async {
                    if (evidenceFile == null) {
                      Fluttertoast.showToast(
                        msg: "กรุณาเพิ่มสลิป",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                      return;
                    }
                    final result = await ref
                        .read(orderControllerProvider.notifier)
                        .onUpdatDeliverySlip('$id', '$cartId', evidenceFile!);

                    if (result) {
                      await ref
                          .read(homeControllerProvider.notifier)
                          .onPostNotification(
                            '$nameStore ทำการจัดส่งเรียบร้อย',
                            OrderStatus.delivering.name,
                            '$uid',
                          );

                      await ref
                          .read(orderControllerProvider.notifier)
                          .onGetOrder(
                            '$uid',
                            '$pharmacyId',
                            OrderStatus.delivering,
                          );

                      Fluttertoast.showToast(
                        msg: "อัพโหลดสลิปสำเร็จ",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );

                      Navigator.of(context).pop();
                    } else {
                      Fluttertoast.showToast(
                        msg: "ไม่สามารถอัพโหลดสลิปได้",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                      );
                    }
                  },
                  text: 'ยืนยันการจัดส่งสินค้า',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
