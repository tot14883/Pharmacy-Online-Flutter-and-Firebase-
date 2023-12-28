import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/order/controller/order_controller.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/order/page/add_review_screen.dart';
import 'package:pharmacy_online/feature/order/page/evidence_bank_transfer_screen.dart';
import 'package:pharmacy_online/feature/order/page/evidence_transportation_screen.dart';
import 'package:pharmacy_online/feature/order/page/upload_bank_transfer_screen.dart';
import 'package:pharmacy_online/feature/order/page/upload_transportation_screen.dart';
import 'package:pharmacy_online/feature/order/widget/card_content_widget.dart';
import 'package:pharmacy_online/feature/order/widget/medicine_list_widget.dart';
import 'package:pharmacy_online/feature/order/widget/row_content_widget.dart';
import 'package:pharmacy_online/feature/order/widget/tracking_content_widget.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/utils/util/date_format.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  static const routeName = 'OrderDetailScreen';

  const OrderDetailScreen({super.key});

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends BaseConsumerState<OrderDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final orderDetail = ref
          .watch(orderControllerProvider.select((value) => value.orderDetail));

      await ref
          .read(storeControllerProvider.notifier)
          .onGetPharmacyDetail('${orderDetail.value?.pharmacyId}');

      await ref
          .read(orderControllerProvider.notifier)
          .onCheckReviewAlready('${orderDetail.value?.id}');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isPharmacy = ref
        .watch(profileControllerProvider.select((value) => value.isPharmacy));

    final orderDetail =
        ref.watch(orderControllerProvider.select((value) => value.orderDetail));

    final isAlreadyReview = ref.watch(
        orderControllerProvider.select((value) => value.isAlreadyReview));

    final isCompletedStatus =
        orderDetail.value?.status == OrderStatus.completed;
    return BaseScaffold(
      bgColor: AppColor.themLineColor,
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          'คำสั่งซื้อ',
          style: AppStyle.txtHeader3,
        ),
        actions: [
          if (isPharmacy && !isCompletedStatus) ...[
            GestureDetector(
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (_) {
                    return BaseDialog(
                      message: 'ต้องการยกเลิกคำสั่งซื้อ?',
                      hasCancel: true,
                      onClick: () async {
                        final _orderDetail = orderDetail.value;
                        final result = await ref
                            .read(orderControllerProvider.notifier)
                            .onDeleteOrder(
                              '${_orderDetail?.id}',
                              '${_orderDetail?.cartId}',
                            );

                        if (result) {
                          await ref
                              .read(orderControllerProvider.notifier)
                              .onGetAllOrder(true);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      },
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16).r,
                child: Text(
                  'ยกเลิกคำสั่งซื้อ',
                  style: AppStyle.txtBody2,
                ),
              ),
            ),
          ],
        ],
        bgColor: AppColor.themLineColor,
      ),
      bodyBuilder: (context, constrained) {
        return AsyncValueWidget(
          value: orderDetail,
          data: (_orderDetail) {
            final id = _orderDetail?.id;
            final cartId = _orderDetail?.cartId;
            final uid = _orderDetail?.uid;
            final pharmacyId = _orderDetail?.pharmacyId;
            final orderNumber = _orderDetail?.orderNumber;
            final convertCreateAt = ref
                .read(baseDateFormatterProvider)
                .convertStringToDateTime('${_orderDetail?.createAt}');
            final createAt = ref
                .read(baseDateFormatterProvider)
                .formatDateWithFreeStyleFormat('dd/MM/yyyy', convertCreateAt);
            final createAtTime = ref
                .read(baseDateFormatterProvider)
                .formatDateWithFreeStyleFormat('HH:mm', convertCreateAt);
            final diagnose = _orderDetail?.diagnose;
            final moreDetail = _orderDetail?.moreDetail ?? 'ไม่ระบุ';
            final cartDetail = _orderDetail?.myCart;
            final fullName = cartDetail?.fullName;
            final phone = cartDetail?.phone;
            final nameStore = cartDetail?.nameStore;
            final address = cartDetail?.address;
            final district = cartDetail?.district;
            final subDistrict = cartDetail?.subDistrict;
            final province = cartDetail?.province;
            final postNumber = cartDetail?.postNumber;
            final summaryPrice = cartDetail?.sumamryPrice;
            final medicineList = cartDetail?.medicineList;
            final deliverySlip = _orderDetail?.deliverySlip;
            final deliveryTextBtn = deliverySlip != null
                ? (_orderDetail?.status == OrderStatus.completed
                    ? 'ดูรูปภาพ'
                    : 'แก้ไขรุปภาพ')
                : 'เพิ่มรูปภาพ';

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
                          RowContentWidget(
                            header: 'ร้าน:',
                            content: '${cartDetail?.nameStore}',
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          RowContentWidget(
                            header: 'เลขที่บิล:',
                            content: '$orderNumber',
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          RowContentWidget(
                            header: 'วันที่:',
                            content: createAt,
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          RowContentWidget(
                            header: 'เวลา:',
                            content: createAtTime,
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          RowContentWidget(
                            header: 'ราคารวมทั้งหมด:',
                            content: '$summaryPrice',
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
                            '$fullName',
                            style: AppStyle.txtBody,
                          ),
                          Text(
                            '$phone',
                            style: AppStyle.txtBody,
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Text(
                            '$address $district $subDistrict $province $postNumber',
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
                      child: MedicineListWidget(
                        medicineList: medicineList ?? [],
                        onChange: (val) {},
                      ),
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
                            '    $diagnose',
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
                            '    $moreDetail',
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
                          if (medicineList == null) ...[
                            const SizedBox.shrink(),
                          ] else ...[
                            for (final medicineItem in medicineList) ...[
                              RowContentWidget(
                                isBold: true,
                                header: '${medicineItem.name}',
                                content: '${medicineItem.howToUse}',
                              ),
                            ],
                          ],
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
                      contentHeight:
                          _orderDetail?.status != OrderStatus.waitingPayment
                              ? 50.h
                              : null,
                      isSuccess:
                          _orderDetail?.status != OrderStatus.waitingPayment ||
                              _orderDetail?.status == OrderStatus.completed,
                      hasBtn: !isPharmacy &&
                          _orderDetail?.status == OrderStatus.waitingPayment,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          UploadBankTransferScreen.routeName,
                        );
                      },
                      number: '1',
                      title: 'การชำระเงิน',
                      content: _orderDetail?.status !=
                                  OrderStatus.waitingPayment &&
                              _orderDetail?.status != OrderStatus.completed
                          ? (isPharmacy ? 'รอลูกค้าชำระเงิน' : 'กรุณาชำระเงิน')
                          : null,
                      btnTxt: 'สแกน QR Code',
                    ),
                    TrackingContentWidget(
                      isSuccess:
                          _orderDetail?.status == OrderStatus.delivering ||
                              _orderDetail?.status == OrderStatus.completed,
                      hasBtn:
                          _orderDetail?.status == OrderStatus.waitingDelivery ||
                              _orderDetail?.status == OrderStatus.delivering ||
                              _orderDetail?.status == OrderStatus.completed,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          EvidenceBankTransferScreen.routeName,
                        );
                      },
                      number: '2',
                      title: 'รอดำเนินการ',
                      content:
                          _orderDetail?.status == OrderStatus.waitingDelivery
                              ? (isPharmacy
                                  ? 'กรุณาตรวจสอบการชำระเงิน'
                                  : 'เภสัชกำลังตรวจสอบการชำระเงิน')
                              : null,
                      contentHeight:
                          _orderDetail?.status == OrderStatus.delivering
                              ? 50.h
                              : null,
                      btnTxt: _orderDetail?.status ==
                                  OrderStatus.waitingDelivery ||
                              _orderDetail?.status == OrderStatus.delivering ||
                              _orderDetail?.status == OrderStatus.completed
                          ? 'ดูรูปภาพ'
                          : '',
                      onTapSecond: () async {
                        await ref
                            .read(orderControllerProvider.notifier)
                            .onUpdateOrder(
                              '$id',
                              '$cartId',
                              status: OrderStatus.delivering,
                            );
                        await ref
                            .read(orderControllerProvider.notifier)
                            .onGetAllOrder(
                              isPharmacy,
                            );
                        await ref
                            .read(orderControllerProvider.notifier)
                            .onGetOrder(
                              '$uid',
                              '$pharmacyId',
                              OrderStatus.delivering,
                            );

                        await ref
                            .read(homeControllerProvider.notifier)
                            .onPostNotification(
                              '$nameStore ยืนยันการชำระเงินแล้ว กำลังทำการจัดส่ง',
                              OrderStatus.delivering.name,
                              '$uid',
                            );
                      },
                      hasSecondBtn:
                          _orderDetail?.status == OrderStatus.waitingDelivery &&
                              isPharmacy,
                      btnTxtSecond:
                          _orderDetail?.status == OrderStatus.waitingDelivery
                              ? 'ยืนยันรายการ'
                              : '',
                    ),
                    TrackingContentWidget(
                      isSuccess: _orderDetail?.status == OrderStatus.completed,
                      hasBtn: _orderDetail?.status == OrderStatus.delivering ||
                          _orderDetail?.status == OrderStatus.completed,
                      onTap: () {
                        if (_orderDetail?.status == OrderStatus.completed) {
                          Navigator.of(context).pushNamed(
                              EvidenceTransportationScreen.routeName);
                          return;
                        }
                        if (isPharmacy) {
                          Navigator.of(context)
                              .pushNamed(UploadTransportationScreen.routeName);
                          return;
                        }
                        Navigator.of(context)
                            .pushNamed(EvidenceTransportationScreen.routeName);
                      },
                      number: '3',
                      title: 'กำลังจัดส่งสินค้า',
                      contentHeight:
                          _orderDetail?.status == OrderStatus.delivering
                              ? null
                              : 50.h,
                      content: _orderDetail?.status == OrderStatus.delivering
                          ? 'เภสัชกำลังเตรียมจัดส่งสินค้า'
                          : null,
                      btnTxt: _orderDetail?.status == OrderStatus.delivering ||
                              _orderDetail?.status == OrderStatus.completed
                          ? (isPharmacy ? deliveryTextBtn : 'ดูรูปภาพ')
                          : '',
                    ),
                    TrackingContentWidget(
                      isSuccess: _orderDetail?.status == OrderStatus.completed,
                      hasBtn: !isPharmacy &&
                          _orderDetail?.status == OrderStatus.delivering,
                      isSecondBtn: false,
                      onTap: () async {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return BaseDialog(
                                message: 'ยืนยันคำสั่งซื้อสำเร็จ',
                                hasCancel: true,
                                onClick: () async {
                                  final result = await ref
                                      .read(orderControllerProvider.notifier)
                                      .onUpdateOrder(
                                        '$id',
                                        '$cartId',
                                        status: OrderStatus.completed,
                                      );
                                  if (result) {
                                    await ref
                                        .read(orderControllerProvider.notifier)
                                        .onGetAllOrder(
                                          isPharmacy,
                                        );

                                    await ref
                                        .read(orderControllerProvider.notifier)
                                        .onGetOrder(
                                          '$uid',
                                          '$pharmacyId',
                                          OrderStatus.completed,
                                        );

                                    await ref
                                        .read(homeControllerProvider.notifier)
                                        .onPostNotification(
                                          '$fullName ยืนยันการจัดส่งสำเร็จ',
                                          OrderStatus.completed.name,
                                          '$pharmacyId',
                                        );

                                    await ref
                                        .read(homeControllerProvider.notifier)
                                        .onPostNotification(
                                          'ยืนยันการจัดส่งสำเร็จ',
                                          OrderStatus.completed.name,
                                          '$uid',
                                        );

                                    Navigator.of(context).pop();
                                    Navigator.of(context)
                                        .pushNamed(AddReviewScreen.routeName);
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "ไม่สามารถยืนยันได้",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                    Navigator.of(context).pop();
                                  }
                                },
                              );
                            });
                      },
                      number: '4',
                      title: 'สินค้าส่งถึงแล้ว',
                      btnTxt: 'ยืนยัน',
                      content: isPharmacy &&
                              _orderDetail?.status == OrderStatus.delivering
                          ? 'รอลูกค้ายืนยันรับสินค้า'
                          : null,
                    ),
                    if (_orderDetail?.status == OrderStatus.completed &&
                        !isPharmacy &&
                        !isAlreadyReview) ...[
                      SizedBox(
                        height: 16.h,
                      ),
                      BaseButton(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AddReviewScreen.routeName);
                        },
                        text: 'เพิ่มรีวิว',
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
