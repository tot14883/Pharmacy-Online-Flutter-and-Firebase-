import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_divider.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/profile/page/change_password_screen.dart';
import 'package:pharmacy_online/feature/profile/page/edit_pharmacy_store_screen.dart';
import 'package:pharmacy_online/feature/profile/page/edit_profile_screen.dart';
import 'package:pharmacy_online/feature/profile/page/edit_qr_code_screen.dart';
import 'package:pharmacy_online/feature/profile/widget/profile_image_widget.dart';
import 'package:pharmacy_online/feature/profile/widget/profile_menu_widget.dart';
import 'package:pharmacy_online/feature/store/page/store_detail_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static const routeName = 'ProfileScreen';

  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      bodyBuilder: (context, constrianed) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'My Profile',
                  style: AppStyle.txtHeader3,
                ),
                SizedBox(
                  height: 16.h,
                ),
                const ProfileImageWidget(
                  imageUrl:
                      'https://www.wilsoncenter.org/sites/default/files/media/images/person/james-person-1.jpg',
                  label: 'Fatima Abdul',
                ),
                SizedBox(
                  height: 16.h,
                ),
                ProfileMenuWidget(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(EditProfileScreen.routeName);
                  },
                  prefixIcon: Assets.icons.icPersion.svg(),
                  label: 'แก้ไขข้อมูลส่วนตัว',
                ),
                const BaseDivider(),
                ProfileMenuWidget(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(StoreDetailScreen.routeName);
                  },
                  prefixIcon: Assets.imgs.imgStore.image(
                    width: 42,
                  ),
                  label: 'แก้ไขข้อมูลร้าน',
                ),
                const BaseDivider(),
                ProfileMenuWidget(
                  onTap: () {
                    Navigator.of(context).pushNamed(EditQRCodeScreen.routeName);
                  },
                  prefixIcon: Assets.imgs.imgQrcode.image(
                    width: 42,
                  ),
                  label: 'แก้ไข QRcode',
                ),
                const BaseDivider(),
                ProfileMenuWidget(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(ChangePasswordScreen.routeName);
                  },
                  prefixIcon: Assets.icons.icSettings.svg(),
                  label: 'เปลี่ยนรหัสผ่าน',
                ),
                const BaseDivider(),
                ProfileMenuWidget(
                  onTap: () {
                    showBaseDialog(
                      context: context,
                      builder: (ctx) {
                        return BaseDialog(
                          dialogLogo: Assets.icons.icLogout.svg(),
                          message: 'ต้องการออกจากระบบ',
                          onClick: () {
                            Navigator.of(context).pop();
                          },
                          hasCancel: true,
                        );
                      },
                    );
                  },
                  prefixIcon: Assets.icons.icWarning.svg(),
                  label: 'ออกจากระบบ',
                ),
                const BaseDivider(),
              ],
            ),
          ),
        );
      },
    );
  }
}
