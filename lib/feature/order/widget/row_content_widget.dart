import 'package:flutter/material.dart';
import 'package:pharmacy_online/core/app_style.dart';

class RowContentWidget extends StatelessWidget {
  final bool isBold;
  final String header;
  final String content;

  const RowContentWidget({
    super.key,
    this.isBold = false,
    required this.header,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            header,
            style: AppStyle.txtBody2.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: AppStyle.txtBody2.copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
