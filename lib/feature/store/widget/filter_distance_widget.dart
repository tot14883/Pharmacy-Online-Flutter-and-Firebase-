import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class FilterDistanceWidget extends StatefulWidget {
  final int maximum;
  final Function(int distance) onUpdate;
  final int? initial;

  // พารามิเตอร์
  const FilterDistanceWidget({
    super.key,
    this.maximum = 50,
    required this.onUpdate,
    this.initial,
  });

  @override
  _FilterDistanceWidgetState createState() => _FilterDistanceWidgetState();
}

class _FilterDistanceWidgetState extends State<FilterDistanceWidget> {
  // ประกาศ initial _distance
  int _distance = 0;

  @override
  void initState() {
    super.initState();
    // ประกาศ initial จาก parameter ของ FilterDistanceWidget
    final initial = widget.initial;
    if (initial != null) {
      _distance = initial;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ปุ่มลบ
        GestureDetector(
          onTap: () {
            if (_distance > 1) {
              setState(() {
                _distance -= 1;
              });

              widget.onUpdate(_distance);
            }
          },
          child: Assets.icons.icMinus.svg(
            width: 16.w,
            height: 16.h,
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        Text('$_distance', style: AppStyle.txtBody),
        SizedBox(
          width: 8.w,
        ),
        // ปุ่มเพิ่ม
        GestureDetector(
          onTap: () {
            if (_distance < widget.maximum) {
              setState(() {
                _distance += 1;
              });

              widget.onUpdate(_distance);
            }
          },
          child: Assets.icons.icAddCart.svg(
            width: 16.w,
            height: 16.h,
          ),
        ),
      ],
    );
  }
}
