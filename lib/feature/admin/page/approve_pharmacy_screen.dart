import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/admin/controller/admin_controller.dart';
import 'package:pharmacy_online/feature/admin/widget/pharmacy_list_widget.dart';

class ApprovePharmacyScreen extends ConsumerStatefulWidget {
  const ApprovePharmacyScreen({super.key});

  @override
  _ApprovePharmacyScreenState createState() => _ApprovePharmacyScreenState();
}

class _ApprovePharmacyScreenState extends ConsumerState<ApprovePharmacyScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      await ref.read(adminControllerProvider.notifier).getPharmacyDetail();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        hideBackButton: true,
        bgColor: AppColor.themeWhiteColor,
        title: Text(
          'คำขออนุมัติ',
          style: AppStyle.txtHeader3,
        ),
      ),
      bgColor: AppColor.themeWhiteColor,
      bodyBuilder: (context, constrained) {
        final pharmacyList = ref.watch(
          adminControllerProvider.select((value) => value.pharmacyInfoList),
        );

        return AsyncValueWidget(
          value: pharmacyList,
          data: (_pharmacyList) {
            if (_pharmacyList == null) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.all(16).r,
              child: PharmacyListWidget(
                pharmacyList: _pharmacyList,
              ),
            );
          },
        );
      },
    );
  }
}
