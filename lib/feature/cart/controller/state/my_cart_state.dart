import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';

part 'my_cart_state.freezed.dart';

@freezed
class MyCartState with _$MyCartState {
  const factory MyCartState({
    BaseFormData? baseFormData,
    String? errMsg,
    CameraPosition? googlePlex,
  }) = _MyCartState;
}
