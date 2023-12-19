import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/cart/controller/my_cart_controller.dart';

class AddressDeliveryScreen extends ConsumerStatefulWidget {
  static const routeName = 'AddressDeliveryScreen';

  const AddressDeliveryScreen({super.key});

  @override
  _AddressDeliveryScreenState createState() => _AddressDeliveryScreenState();
}

class _AddressDeliveryScreenState
    extends BaseConsumerState<AddressDeliveryScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  CameraPosition? _kGooglePlex;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ref.read(myCartControllerProvider.notifier).onGetLocation();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _onListening();

    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          'ตำแหน่งที่อยู่การจัดส่ง',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themeWhiteColor,
      ),
      bgColor: AppColor.themeWhiteColor,
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 250.h,
                  child: GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: _kGooglePlex!,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                const BaseTextField(
                  label: 'ชื่อ-นามสกุลผู้รับ',
                  isReadOnly: true,
                  isShowLabelField: true,
                  placeholder: 'ชื่อ-นามสกุลผู้รับ',
                ),
                SizedBox(
                  height: 16.h,
                ),
                const BaseTextField(
                  label: 'เบอร์โทรศัพท์ผู้รับ',
                  isReadOnly: true,
                  isShowLabelField: true,
                  placeholder: 'เบอร์โทรศัพท์ผู้รับ',
                ),
                SizedBox(
                  height: 16.h,
                ),
                const BaseTextField(
                  label: 'บ้านเลขที่/หมู่บ้าน/อาคาร/ซอย/ถนน ผู้รับ',
                  isReadOnly: true,
                  isShowLabelField: true,
                  placeholder: 'ที่อยู่',
                ),
                SizedBox(
                  height: 16.h,
                ),
                const BaseTextField(
                  label: 'ตำบล/แขวง',
                  isReadOnly: true,
                  isShowLabelField: true,
                  placeholder: 'ตำบล/แขวง',
                ),
                SizedBox(
                  height: 16.h,
                ),
                const BaseTextField(
                  label: 'อำเภอ/เขต',
                  isReadOnly: true,
                  isShowLabelField: true,
                  placeholder: 'อำเภอ/เขต',
                ),
                SizedBox(
                  height: 16.h,
                ),
                const BaseTextField(
                  label: 'จังหวัด',
                  isReadOnly: true,
                  isShowLabelField: true,
                  placeholder: 'จังหวัด',
                ),
                SizedBox(
                  height: 16.h,
                ),
                BaseButton(
                  onTap: () {},
                  text: 'บันทึก',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onListening() {
    ref.listen(myCartControllerProvider.select((value) => value.errMsg),
        (previous, next) {
      if (next != null) {
        showDialog(
            context: context,
            builder: (context) {
              return BaseDialog(
                message: next,
              );
            });
      }
    });
  }
}
