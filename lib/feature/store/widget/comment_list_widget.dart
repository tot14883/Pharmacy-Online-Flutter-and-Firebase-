import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_divider.dart';
import 'package:pharmacy_online/feature/store/widget/comment_item_widget.dart';

class CommentListWidget extends ConsumerWidget {
  const CommentListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return const CommentItemWidget();
      },
      separatorBuilder: (_, __) => const BaseDivider(),
    );
  }
}
