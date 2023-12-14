import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/base_widget/base_upload_image.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class UploadBankTransferScreen extends ConsumerStatefulWidget {
  static const routeName = 'UploadBankTransferScreen';

  const UploadBankTransferScreen({super.key});

  @override
  _UploadBankTransferScreenState createState() =>
      _UploadBankTransferScreenState();
}

class _UploadBankTransferScreenState
    extends BaseConsumerState<UploadBankTransferScreen> {
  @override
  Widget build(BuildContext context) {
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
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8).r,
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
                      child: Assets.imgs.imgQrcode.image(),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Assets.icons.icDownload.svg(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Text(
                  'จำนวนเงิน 63.99 บาท',
                  style: AppStyle.txtHeader3,
                ),
                SizedBox(
                  height: 16.h,
                ),
                const BaseTextField(
                  label: 'วันที่ชำระ',
                  isShowLabelField: true,
                ),
                SizedBox(
                  height: 16.h,
                ),
                const BaseTextField(
                  label: 'จำนวนเงิน',
                  isShowLabelField: true,
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseUploadImage(
                  label: 'หลักฐานการโอน',
                  onUpload: (val) {},
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseButton(
                  onTap: () {},
                  text: 'ยืนยันการชำระเงิน',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
