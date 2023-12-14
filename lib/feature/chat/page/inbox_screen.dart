import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/chat/widget/inbox_list_widget.dart';

class InboxScreen extends ConsumerStatefulWidget {
  const InboxScreen({super.key});

  @override
  _InboxScreenState createState() => _InboxScreenState();
}

class _InboxScreenState extends BaseConsumerState<InboxScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      bgColor: AppColor.themLineColor,
      bodyBuilder: (context, constrined) {
        return Padding(
          padding: const EdgeInsets.all(16).r,
          child: const InboxListWidget(),
        );
      },
    );
  }
}
