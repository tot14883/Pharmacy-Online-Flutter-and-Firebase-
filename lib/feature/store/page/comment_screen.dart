import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/store/widget/comment_list_widget.dart';

class CommentScreen extends ConsumerStatefulWidget {
  static const routeName = 'CommentScreen';

  const CommentScreen({super.key});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends BaseConsumerState<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(
          'Comments',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themeWhiteColor,
      ),
      bgColor: AppColor.themLineColor,
      bodyBuilder: (context, constrained) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 72).r,
              child: const CommentListWidget(),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16).r,
                color: AppColor.themeWhiteColor,
                child: Row(
                  children: [
                    const Expanded(
                      child: BaseTextField(
                        placeholder: 'comment',
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    BaseButton(
                      width: 60.w,
                      onTap: () {},
                      text: 'ส่ง',
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
