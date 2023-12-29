import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';
import 'package:pharmacy_online/feature/admin/page/user_detail_screen.dart';

class PharmacyArgs {
  final PharmacyInfoResponse pharmacyItem;

  PharmacyArgs({required this.pharmacyItem});
}

class PharmacyStoreDetaillScreen extends ConsumerStatefulWidget {
  static const routeName = 'PharmacyStoreDetaillScreen';
  final PharmacyArgs args;

  const PharmacyStoreDetaillScreen({
    super.key,
    required this.args,
  });

  @override
  _PharmacyStoreDetaillScreenState createState() =>
      _PharmacyStoreDetaillScreenState();
}

class _PharmacyStoreDetaillScreenState
    extends ConsumerState<PharmacyStoreDetaillScreen> {
  @override
  Widget build(BuildContext context) {
    final pharmacyStoreInfo = widget.args.pharmacyItem;

    final pharmacyStoreImg = pharmacyStoreInfo.storeImg;
    final licensePharmacyStore = pharmacyStoreInfo.licenseStoreImg;
    final nameStore = pharmacyStoreInfo.nameStore;
    final phoneStore = pharmacyStoreInfo.phoneStore;
    final address = pharmacyStoreInfo.addressStore;
    final timeClosing = pharmacyStoreInfo.timeClosing;
    final timeOpening = pharmacyStoreInfo.timeOpening;
    final licenseStore = pharmacyStoreInfo.licenseStore;

    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        elevation: 0,
        title: Text(
          'แก้ไขข้อมูลร้าน',
          style: AppStyle.txtHeader3,
        ),
      ),
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BaseImageView(
                  url: pharmacyStoreImg,
                  width: 350.w,
                  height: 350.h,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseTextField(
                  isReadOnly: true,
                  initialValue: nameStore,
                  placeholder: "ชื่อร้าน",
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseTextField(
                  placeholder: "ที่อยู่",
                  initialValue: address,
                  isReadOnly: true,
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseTextField(
                  initialValue: phoneStore,
                  isReadOnly: true,
                  placeholder: "เบอร์โทรศัพท์",
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseTextField(
                  placeholder: "เวลาเปิด",
                  isReadOnly: true,
                  initialValue: timeOpening,
                  textInputType: TextInputType.datetime,
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseTextField(
                  isReadOnly: true,
                  placeholder: "เวลาปิด",
                  initialValue: timeClosing,
                  textInputType: TextInputType.datetime,
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseTextField(
                  isReadOnly: true,
                  placeholder: "เลขที่ใบอนุญาตร้าน",
                  initialValue: licenseStore,
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseImageView(
                  url: licensePharmacyStore,
                  width: 250.w,
                  height: 250.h,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseButton(
                  onTap: () async {
                    Navigator.of(context).pushNamed(
                      UserDetailScreen.routeName,
                      arguments: PharmacyArgs(pharmacyItem: pharmacyStoreInfo),
                    );
                  },
                  text: 'ดูข้อมูลเภสัชกรประจำร้าน',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
