import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/order/widget/order_list_widget.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends BaseConsumerState<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 4,
      child: BaseScaffold(
        appBar: AppBar(
          backgroundColor: AppColor.themeWhiteColor,
          title: Text(
            'คำสั่งซื้อ',
            style: AppStyle.txtHeader3,
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: AppColor.themePrimaryColor,
            tabs: <Widget>[
              Tab(
                child: Text(
                  'ที่ต้องชำระ',
                  softWrap: false,
                  style: AppStyle.txtBody2,
                ),
              ),
              Tab(
                child: Text(
                  'ที่ต้องจัดส่ง',
                  softWrap: false,
                  style: AppStyle.txtBody2,
                ),
              ),
              Tab(
                child: Text(
                  'ที่ต้องได้รับ',
                  softWrap: false,
                  style: AppStyle.txtBody2,
                ),
              ),
              Tab(
                child: Text(
                  'สำเร็จ',
                  softWrap: false,
                  style: AppStyle.txtBody2,
                ),
              ),
            ],
          ),
        ),
        bodyBuilder: (context, constrined) {
          return const TabBarView(
            children: <Widget>[
              OrderListWidget(),
              OrderListWidget(),
              OrderListWidget(),
              OrderListWidget(),
            ],
          );
        },
      ),
    );
  }
}
