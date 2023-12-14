import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';

part 'authentication_state.freezed.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState({
    BaseFormData? baseFormData,
    String? errMsg,
  }) = _AuthenticationState;
}
