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
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/reviews_response.dart';
import 'package:pharmacy_online/feature/store/widget/comment_list_widget.dart';

class CommentArgs {
  final ReviewsResponse reviewItem;

  CommentArgs({
    required this.reviewItem,
  });
}

class CommentScreen extends ConsumerStatefulWidget {
  static const routeName = 'CommentScreen';
  final CommentArgs args;

  const CommentScreen({
    super.key,
    required this.args,
  });

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends BaseConsumerState<CommentScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviewItem = widget.args.reviewItem;

    final commentList = ref
        .watch(storeControllerProvider.select((value) => value.commentList))
        .value;

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
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              if (commentList != null) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 72).r,
                  child: CommentListWidget(
                    commentList: commentList,
                  ),
                ),
              ],
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(16).r,
                  color: AppColor.themeWhiteColor,
                  child: Row(
                    children: [
                      Expanded(
                        child: BaseTextField(
                          controller: messageController,
                          placeholder: 'comment',
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      BaseButton(
                        width: 60.w,
                        onTap: () async {
                          if (messageController.text.isEmpty) {
                            return;
                          }

                          await ref
                              .read(storeControllerProvider.notifier)
                              .onAddComment(
                                '${reviewItem.id}',
                                '${reviewItem.pharmacyId}',
                                '${reviewItem.uid}',
                                messageController.text,
                              );

                          await ref
                              .read(storeControllerProvider.notifier)
                              .onGetComment('${reviewItem.id}');

                          messageController.clear();
                        },
                        text: 'ส่ง',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
