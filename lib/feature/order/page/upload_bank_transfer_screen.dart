import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/base_widget/base_upload_image.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/order/controller/order_controller.dart';
import 'package:pharmacy_online/feature/order/enum/field_bank_transfer_enum.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/util/base_permission_handler.dart';
import 'package:pharmacy_online/utils/util/date_format.dart';
import 'package:pharmacy_online/utils/util/vaildators.dart';

class UploadBankTransferScreen extends ConsumerStatefulWidget {
  static const routeName = 'UploadBankTransferScreen';

  const UploadBankTransferScreen({super.key});

  @override
  _UploadBankTransferScreenState createState() =>
      _UploadBankTransferScreenState();
}

class _UploadBankTransferScreenState
    extends BaseConsumerState<UploadBankTransferScreen> {
  final _globalKey = GlobalKey();
  TextEditingController slipDateTime = TextEditingController();
  XFile? evidenceImg;
  final formKey = GlobalKey<BaseFormState>();

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyDetail = ref
        .watch(storeControllerProvider.select((value) => value.pharmacyDetail));
    final orderDetail =
        ref.watch(orderControllerProvider.select((value) => value.orderDetail));

    final uid = orderDetail.value?.uid;
    final pharmacyId = orderDetail.value?.pharmacyId;
    final summaryPrice = orderDetail.value?.myCart?.sumamryPrice;
    final cartId = orderDetail.value?.cartId;
    final id = orderDetail.value?.id;

    return AsyncValueWidget(
      value: pharmacyDetail,
      data: (_pharmacyDetail) {
        final qrCode = _pharmacyDetail?.qrCode;

        return BaseScaffold(
          appBar: BaseAppBar(
            bgColor: AppColor.themeWhiteColor,
            title: Text(
              'ชำระค่าสินค้า',
              style: AppStyle.txtHeader3,
            ),
            elevation: 0,
          ),
          bodyBuilder: (context, constrained) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16).r,
                child: BaseForm(
                  key: formKey,
                  onChanged:
                      ref.read(orderControllerProvider.notifier).onChanged,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(32).r,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColor.themePrimaryColor,
                                width: 1, // red as border color
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  16,
                                ),
                              ),
                            ),
                            child: RepaintBoundary(
                              key: _globalKey,
                              child: BaseImageView(
                                url: '$qrCode',
                                width: 250.w,
                                height: 250.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: () async {
                                final granted = await ref
                                    .read(basePermissionHandlerProvider)
                                    .requestStoragePermission();

                                if (granted) {
                                  RenderRepaintBoundary boundary = _globalKey
                                          .currentContext!
                                          .findRenderObject()
                                      as RenderRepaintBoundary;
                                  final image = await boundary.toImage();
                                  ByteData? byteData = await (image.toByteData(
                                    format: ImageByteFormat.png,
                                  ));
                                  if (byteData != null) {
                                    final result =
                                        await ImageGallerySaver.saveImage(
                                      byteData.buffer.asUint8List(),
                                    );
                                    if (result['isSuccess']) {
                                      Fluttertoast.showToast(
                                        msg: "Downloaded",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "ไม่สามารถ Download ได้",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    }
                                  }
                                }
                              },
                              child: Assets.icons.icDownload.svg(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      Text(
                        'จำนวนเงิน $summaryPrice บาท',
                        style: AppStyle.txtHeader3,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      BaseTextField(
                        label: 'วันที่ชำระ',
                        isReadOnly: true,
                        controller: slipDateTime,
                        isShowLabelField: true,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101),
                          );

                          final selectedTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          if (picked != null && selectedTime != null) {
                            final hour =
                                selectedTime.hour.toString().padLeft(2, "0");
                            final min =
                                selectedTime.minute.toString().padLeft(2, "0");

                            final result = ref
                                .read(baseDateFormatterProvider)
                                .formatDateTimeWithNameOfMonth(
                                  picked,
                                  'dd/MM/yyyy',
                                );

                            slipDateTime.text = '$result $hour:$min';

                            ref
                                .read(orderControllerProvider.notifier)
                                .setBankTransferDateTime('$result $hour:$min');
                          }
                        },
                        validator: Validators.combine(
                          [
                            Validators.withMessage(
                              "Required",
                              Validators.isEmpty,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      BaseTextField(
                        fieldKey: FieldBankTransfer.payPrice,
                        label: 'จำนวนเงิน',
                        isShowLabelField: true,
                        validator: Validators.combine(
                          [
                            Validators.withMessage(
                              "Required",
                              Validators.isEmpty,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      BaseUploadImage(
                        label: 'หลักฐานการโอน',
                        onUpload: (val) {
                          setState(() {
                            evidenceImg = val;
                          });
                        },
                      ),
                      if (evidenceImg != null) ...[
                        SizedBox(
                          height: 8.h,
                        ),
                        BaseImageView(
                          file: File(evidenceImg!.path),
                          width: 150.w,
                          height: 150.h,
                          fit: BoxFit.cover,
                        ),
                      ],
                      SizedBox(
                        height: 16.h,
                      ),
                      BaseButton(
                        onTap: () {
                          formKey.currentState?.save(
                            onSave: (_) async {
                              if (slipDateTime.text.isEmpty) {
                                Fluttertoast.showToast(
                                  msg: "กรุณาระบุวันที่ชำระ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                                return;
                              }

                              if (evidenceImg == null) {
                                Fluttertoast.showToast(
                                  msg: "กรุณาอัพโหลดสลิป",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                                return;
                              }

                              final result = await ref
                                  .read(orderControllerProvider.notifier)
                                  .onUpdatBankTransfer(
                                    '$id',
                                    '$cartId',
                                    slipDateTime.text,
                                    evidenceImg!,
                                  );

                              if (result) {
                                await ref
                                    .read(homeControllerProvider.notifier)
                                    .onPostNotification(
                                      'ทำการชำระเงินแล้ว รอเภสัชทำการจัดส่ง',
                                      OrderStatus.waitingDelivery.name,
                                      '$uid',
                                    );

                                await ref
                                    .read(orderControllerProvider.notifier)
                                    .onGetOrder(
                                      '$uid',
                                      '$pharmacyId',
                                      OrderStatus.waitingDelivery,
                                    );

                                Fluttertoast.showToast(
                                  msg: "อัพโหลดสลิปสำเร็จ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );

                                Navigator.of(context).pop();
                              } else {
                                Fluttertoast.showToast(
                                  msg: "อัพโหลดสลิปไม่สำเร็จ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              }
                            },
                          );
                        },
                        text: 'ยืนยันการชำระเงิน',
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
