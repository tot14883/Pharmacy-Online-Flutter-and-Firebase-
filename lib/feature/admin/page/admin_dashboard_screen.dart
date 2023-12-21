import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/admin/page/approve_pharmacy_screen.dart';
import 'package:pharmacy_online/feature/admin/widget/admin_bottom_navigation_widget.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/profile/page/profile_screen.dart';
import 'package:pharmacy_online/feature/store/page/central_medicine_warehouse_screen.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  static const routeName = 'AdminDashboardScreen';

  const AdminDashboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends BaseConsumerState<AdminDashboardScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(profileControllerProvider.notifier).onGetUserInfo();
      await ref.read(profileControllerProvider.notifier).onGetPharmacyStore();
    });
    super.initState();
  }

  int _currentPage = 0;

  final List<Widget> pages = const [
    ApprovePharmacyScreen(),
    CentralMedicineWarehouseScreen(),
    ProfileScreen(),
  ];

  final List<String> pagesTitle = const [
    "หน้าหลัก",
    "คลังยา",
    "บัญชี",
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      bodyBuilder: (context, constraints) {
        return pages[_currentPage];
      },
      bottomNavigationBar: AdminBottomNavigationWidget(
        onChange: (value) {
          setState(() {
            _currentPage = value;
          });
        },
      ),
    );
  }
}
