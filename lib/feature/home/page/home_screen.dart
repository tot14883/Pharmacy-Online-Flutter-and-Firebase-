import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/chat/page/request_consult_screen.dart';
import 'package:pharmacy_online/feature/home/widget/menu_buttton_widget.dart';
import 'package:pharmacy_online/feature/home/widget/user_profile_header_widget.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/page/my_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = 'HomeScreen';

  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isPharmacy = ref
        .watch(profileControllerProvider.select((value) => value.isPharmacy));

    return BaseScaffold(
      bodyBuilder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const UserProfileHeaderWidget(),
              SizedBox(
                height: 24.h,
              ),
              Assets.imgs.imgPharmacyStore.image(),
              SizedBox(
                height: 16.h,
              ),
              Wrap(
                spacing: 16.0,
                runSpacing: 16.0,
                children: [
                  if (!isPharmacy) ...[
                    MenuButtonWidget(
                      onTap: () {},
                      imgWidget: Assets.icons.icRefresh.svg(),
                      label: 'ค้นหาอัตโนมัติ',
                    ),
                    MenuButtonWidget(
                      onTap: () {},
                      isSecondBtn: true,
                      imgWidget: Assets.icons.icLocationPin.svg(),
                      label: 'ค้นหาร้านยา',
                    ),
                    MenuButtonWidget(
                      onTap: () {},
                      isSecondBtn: true,
                      imgWidget: Assets.icons.icCart.svg(),
                      label: 'คำสั่งซื้อ',
                    ),
                    MenuButtonWidget(
                      onTap: () {},
                      isSecondBtn: true,
                      imgWidget: Assets.icons.icChatLeftText.svg(),
                      label: 'ประวัติการสนทนา',
                    ),
                  ],
                  if (isPharmacy) ...[
                    MenuButtonWidget(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(RequestConsultScreen.routeName);
                      },
                      imgWidget: Assets.icons.icChatMarkUnread.svg(),
                      label: 'การขอรับการปรึกษา',
                    ),
                    MenuButtonWidget(
                      onTap: () {
                        ref
                            .read(storeControllerProvider.notifier)
                            .onGetCentralMedicineWarehouse();
                        ref
                            .read(storeControllerProvider.notifier)
                            .onGetMedicineWarehouse();

                        Navigator.of(context)
                            .pushNamed(MyMedicineWarehouseScreen.routeName);
                      },
                      isSecondBtn: true,
                      imgWidget: Assets.imgs.imgShop.image(),
                      label: 'คลังยา',
                    ),
                    MenuButtonWidget(
                      onTap: () {},
                      isSecondBtn: true,
                      imgWidget: Assets.icons.icCart.svg(),
                      label: 'คำสั่งซื้อ',
                    ),
                    MenuButtonWidget(
                      onTap: () {},
                      isSecondBtn: true,
                      imgWidget: Assets.icons.icChat.svg(),
                      label: 'ประวัติการสนทนา',
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
