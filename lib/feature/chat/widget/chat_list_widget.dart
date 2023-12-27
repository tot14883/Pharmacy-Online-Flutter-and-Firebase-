import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/feature/chat/widget/chat_item_widget.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';

class ChatListWidget extends ConsumerWidget {
  final List<ChatWithPharmacyResponse> messageList;

  const ChatListWidget({super.key, required this.messageList});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: messageList.length,
      itemBuilder: (context, index) {
        final messageItem = messageList[index];

        return ChatItemWidget(messageItem: messageItem);
      },
      separatorBuilder: (_, __) => SizedBox(
        height: 16.h,
      ),
    );
  }
}
