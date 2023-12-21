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
import 'package:pharmacy_online/feature/admin/page/pharmacy_store_detail_screen.dart';
import 'package:pharmacy_online/feature/profile/enum/field_user_info_enum.dart';

class UserDetailScreen extends ConsumerStatefulWidget {
  static const routeName = 'UserDetailScreen';
  final PharmacyArgs args;

  const UserDetailScreen({
    super.key,
    required this.args,
  });

  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends ConsumerState<UserDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final userInfo = widget.args.pharmacyItem;

    final profileImg = userInfo.profileImg;
    final fullname = userInfo.fullName;
    final phone = userInfo.phone;
    final licensePharmacy = userInfo.licensePharmacy;
    final licensePharmacyImg = userInfo.licensePharmacyImg;

    return BaseScaffold(
      appBar: BaseAppBar(
        bgColor: AppColor.themeWhiteColor,
        elevation: 0,
        title: Text(
          'แก้ไขข้อมูลส่วนตัว',
          style: AppStyle.txtHeader3,
        ),
      ),
      bodyBuilder: (context, constrianed) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BaseImageView(
                  url: profileImg,
                  width: 350.w,
                  height: 350.h,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseTextField(
                  isReadOnly: true,
                  initialValue: fullname,
                  placeholder: "ชื่อนาม-สกุล",
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseTextField(
                  isReadOnly: true,
                  initialValue: phone,
                  placeholder: "เบอร์โทรศัพท์",
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseTextField(
                  fieldKey: FieldUserInfo.licensePharmacy,
                  initialValue: licensePharmacy,
                  isReadOnly: true,
                  placeholder: "เลขที่ใบอนุญาตเภสัชกร",
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseImageView(
                  url: licensePharmacyImg,
                  width: 250.w,
                  height: 250.h,
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseButton(
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                  text: 'ดูข้อมูลร้านของเภสัชกร',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
