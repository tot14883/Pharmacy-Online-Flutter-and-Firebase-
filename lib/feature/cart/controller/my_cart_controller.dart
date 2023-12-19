import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';
import 'package:pharmacy_online/core/router/app_naviagor.dart';
import 'package:pharmacy_online/feature/cart/controller/state/my_cart_state.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';

final myCartControllerProvider =
    StateNotifierProvider<MyCartController, MyCartState>(
  (ref) {
    final baseFormData = ref.watch(baseFormDataProvider);
    final baseUtils = ref.watch(baseUtilsProvider);
    final appNavigator = ref.watch(appNavigatorProvider);

    return MyCartController(
      ref,
      const MyCartState(),
      baseFormData,
      baseUtils,
      appNavigator,
    );
  },
);

class MyCartController extends StateNotifier<MyCartState> {
  final Ref _ref;
  final BaseFormData _baseFormData;
  final LoaderController _loader;
  final BaseUtils _baseUtils;
  final AppNavigator _appNavigator;

  MyCartController(
    this._ref,
    MyCartState state,
    this._baseFormData,
    this._baseUtils,
    this._appNavigator,
  )   : _loader = _ref.read(loaderControllerProvider.notifier),
        super(state);

  void onChanged(BaseFormData baseFormData) {
    final newData = _baseFormData.copyAndMerge(baseFormData);
    state = state.copyWith(baseFormData: newData);
  }

  void onGetLocation() async {
    final result = await _baseUtils.getLocation();

    result.when((success) {
      state = state.copyWith(
        googlePlex: CameraPosition(
          target: LatLng(success.latitude, success.longitude),
          zoom: 14.4746,
        ),
      );
    }, (error) {
      state = state.copyWith(errMsg: error.message);
    });
  }

  void clearForm() {
    state = state.copyWith(baseFormData: null);
  }
}
