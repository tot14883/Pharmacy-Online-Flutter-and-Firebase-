import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/store/widget/filter_distance_widget.dart';

class FilterWidget extends ConsumerStatefulWidget {
  const FilterWidget({super.key});

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends BaseConsumerState<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BaseTextField(
            label: 'ค้นหายา',
            isShowLabelField: true,
            onChange: (val) {},
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            'ระยะทาง (กิโลเมตร)',
            style: AppStyle.txtBody,
          ),
          FilterDistanceWidget(
            onUpdate: (val) {},
          ),
        ],
      ),
    );
  }
}
