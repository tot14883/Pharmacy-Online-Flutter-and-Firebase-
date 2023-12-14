import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_divider.dart';
import 'package:pharmacy_online/feature/store/widget/review_item_widget.dart';

class ReviewListWidget extends ConsumerWidget {
  const ReviewListWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        return const ReviewItemWidget();
      },
      separatorBuilder: (_, __) => const BaseDivider(),
    );
  }
}
