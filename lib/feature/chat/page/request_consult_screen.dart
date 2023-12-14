import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/chat/widget/request_consult_list_widget.dart';

class RequestConsultScreen extends ConsumerStatefulWidget {
  static const routeName = 'RequestConsultScreen';
  const RequestConsultScreen({super.key});

  @override
  _RequestConsultScreenState createState() => _RequestConsultScreenState();
}

class _RequestConsultScreenState
    extends BaseConsumerState<RequestConsultScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        bgColor: AppColor.themLineColor,
        title: Text(
          'คำขอรับการปรึกษา',
          style: AppStyle.txtHeader3,
        ),
      ),
      bgColor: AppColor.themLineColor,
      bodyBuilder: (context, constrined) {
        return Padding(
          padding: const EdgeInsets.all(16).r,
          child: const RequestConsiltListWidget(),
        );
      },
    );
  }
}
