import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_bottom_navigation_widget.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/chat/page/inbox_screen.dart';
import 'package:pharmacy_online/feature/home/page/home_screen.dart';
import 'package:pharmacy_online/feature/order/page/orders_screen.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/profile/page/profile_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static const routeName = 'DashboardScreen';

  const DashboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends BaseConsumerState<DashboardScreen> {
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
    HomeScreen(),
    OrdersScreen(),
    InboxScreen(),
    ProfileScreen(),
  ];

  final List<String> pagesTitle = const [
    "Home",
    "Order",
    "Chat",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      bodyBuilder: (context, constraints) {
        return pages[_currentPage];
      },
      bottomNavigationBar: BottomNavigationWidget(
        onChange: (value) {
          setState(() {
            _currentPage = value;
          });
        },
      ),
    );
  }
}
