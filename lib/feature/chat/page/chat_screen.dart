import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/cart/controller/my_cart_controller.dart';
import 'package:pharmacy_online/feature/cart/page/my_cart_screen.dart';
import 'package:pharmacy_online/feature/chat/controller/chat_controller.dart';
import 'package:pharmacy_online/feature/chat/widget/chat_list_widget.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';
import 'package:pharmacy_online/feature/store/page/my_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';
import 'package:pharmacy_online/utils/image_picker/image_picker_provider.dart';
import 'package:pharmacy_online/utils/image_picker/model/image_picker_config_request.dart';
import 'package:pharmacy_online/utils/util/base_permission_handler.dart';

class ChatArgs {
  final ChatWithPharmacyResponse chatWithPharmacyItem;
  final bool isPharmacy;

  ChatArgs({
    required this.chatWithPharmacyItem,
    this.isPharmacy = false,
  });
}

class ChatScreen extends ConsumerStatefulWidget {
  static const routeName = 'ChatScreen';

  final ChatArgs args;

  const ChatScreen({
    super.key,
    required this.args,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends BaseConsumerState<ChatScreen> {
  TextEditingController chatController = TextEditingController();
  XFile? chatImgfile;
  Timer? timer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final id = widget.args.chatWithPharmacyItem.id;

      await ref
          .read(chatControllerProvider.notifier)
          .onGetMessageChatUsecase('$id');
    });
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) async {
      final id = widget.args.chatWithPharmacyItem.id;

      await ref
          .read(chatControllerProvider.notifier)
          .onGetRealTimeMessageChatUsecase('$id');
    });
  }

  @override
  void dispose() {
    chatController.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    final profileImg = args.chatWithPharmacyItem.profileImg;
    final fullName = args.chatWithPharmacyItem.fullName;

    final nameStore = args.chatWithPharmacyItem.nameStore;
    final messageList = ref
        .watch(
          chatControllerProvider.select((value) => value.messageList),
        )
        .value;
    final isPharmacy = ref.watch(
      profileControllerProvider.select((value) => value.isPharmacy),
    );

    final _messageList = messageList;

    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        bgColor: AppColor.themeWhiteColor,
        actions: [
          GestureDetector(
            onTap: () {
              if (widget.args.isPharmacy) {
                Navigator.of(context).pushNamed(
                  MyMedicineWarehouseScreen.routeName,
                  arguments: MyMedicineWarehouseArgs(
                    isFromChat: true,
                    chatWithPharmacyItem: args.chatWithPharmacyItem,
                  ),
                );
                return;
              }

              ref.read(myCartControllerProvider.notifier).onGetCart(
                    '${args.chatWithPharmacyItem.uid}',
                    '${args.chatWithPharmacyItem.pharmacyId}',
                    OrderStatus.waitingConfirmOrder,
                  );

              Navigator.of(context).pushNamed(
                MyCartScreen.routeName,
                arguments: MyCartArgs(
                  isPharmacy: widget.args.isPharmacy,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8).r,
              child: widget.args.isPharmacy
                  ? Assets.icons.icAddShoppingCart.svg()
                  : Assets.icons.icCart.svg(
                      width: 28.w,
                      height: 28.h,
                    ),
            ),
          ),
        ],
      ),
      bgColor: AppColor.themeGrayLight,
      bodyBuilder: (context, constrained) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(15).r,
                    color: AppColor.themeWhiteColor,
                    child: Row(
                      children: [
                        BaseImageView(
                          url: profileImg,
                          width: 60.w,
                          height: 60.h,
                          radius: BorderRadius.circular(12),
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          isPharmacy ? '$fullName' : '$nameStore',
                          style: AppStyle.txtCaption,
                        ),
                      ],
                    ),
                  ),
                  if (_messageList != null) ...[
                    SizedBox(
                      height: 16.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: ChatListWidget(
                        messageList: _messageList,
                      ),
                    ),
                  ],
                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(8).r,
                  color: AppColor.themeWhiteColor,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final isGrant = await ref
                              .read(basePermissionHandlerProvider)
                              .requestStoragePermission();

                          if (isGrant) {
                            final result = await ref
                                .read(imagePickerUtilsProvider)
                                .getImage(
                                  const ImagePickerConfigRequest(
                                    source: ImageSource.gallery,
                                    maxHeight: 1920,
                                    maxWidth: 2560,
                                    imageQuality: 30,
                                    isMaximum2MB: true,
                                  ),
                                );

                            result.when(
                              (success) async {
                                final id = widget.args.chatWithPharmacyItem.id;

                                await ref
                                    .read(chatControllerProvider.notifier)
                                    .onPushMessageChatUsecase(
                                      '$id',
                                      '',
                                      success[0],
                                    );
                              },
                              (error) async {
                                await showBaseDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return BaseDialog(
                                      message: error.message,
                                    );
                                  },
                                );
                              },
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8).r,
                          child: Assets.icons.icAttach.svg(),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Expanded(
                        child: BaseTextField(
                          controller: chatController,
                          placeholder: 'Message',
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          final id = widget.args.chatWithPharmacyItem.id;
                          ref
                              .read(chatControllerProvider.notifier)
                              .onPushMessageChatUsecase(
                                '$id',
                                chatController.text,
                                chatImgfile,
                              );

                          chatController.clear();
                        },
                        child: Assets.icons.icSend.svg(),
                      )
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
