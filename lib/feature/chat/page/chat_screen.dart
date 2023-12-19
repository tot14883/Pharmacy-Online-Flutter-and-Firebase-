import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/cart/page/my_cart_screen.dart';
import 'package:pharmacy_online/feature/chat/widget/chat_list_widget.dart';
import 'package:pharmacy_online/feature/store/page/my_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const routeName = 'ChatScreen';

  final bool isPharmacy;

  const ChatScreen({
    super.key,
    this.isPharmacy = false,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends BaseConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        bgColor: AppColor.themeWhiteColor,
        actions: [
          GestureDetector(
            onTap: () {
              if (widget.isPharmacy) {
                Navigator.of(context)
                    .pushNamed(MyMedicineWarehouseScreen.routeName);
                return;
              }

              Navigator.of(context).pushNamed(
                MyCartScreen.routeName,
                arguments: MyCartArgs(
                  isPharmacy: false,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8).r,
              child: widget.isPharmacy
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
                          url:
                              'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                          width: 60.w,
                          height: 60.h,
                          radius: BorderRadius.circular(12),
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          'นีรชา แก้วแสนตอ',
                          style: AppStyle.txtCaption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: const ChatListWidget(),
                  ),
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
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8).r,
                          child: Assets.icons.icAttach.svg(),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      const Expanded(
                        child: BaseTextField(
                          placeholder: 'Message',
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      GestureDetector(
                        onTap: () {},
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
