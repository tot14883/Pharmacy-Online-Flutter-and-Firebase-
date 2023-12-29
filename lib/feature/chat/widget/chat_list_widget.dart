import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/chat/widget/chat_item_widget.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';

class ChatListWidget extends ConsumerStatefulWidget {
  final List<ChatWithPharmacyResponse> messageList;

  const ChatListWidget({super.key, required this.messageList});

  @override
  _ChatListWidgetState createState() => _ChatListWidgetState();
}

class _ChatListWidgetState extends BaseConsumerState<ChatListWidget> {
  final ScrollController _scrollController = ScrollController();
  bool isFirstRender = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      // final uid = ref
      //     .read(baseSharePreferenceProvider)
      //     .getString(BaseSharePreferenceKey.userId);
      // final isLastMessageIsMe = widget.messageList.last.uid == uid;

      if (mounted) {
        if (isFirstRender) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

          await Future.delayed(
            const Duration(milliseconds: 200),
          );
          isFirstRender = false;
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageList = widget.messageList;

    return ListView.separated(
      controller: _scrollController,
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
