import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/feature/authentication/model/response/pharmacy_store_response.dart';
import 'package:pharmacy_online/feature/authentication/model/response/user_info_response.dart';

part 'profile_state.freezed.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    BaseFormData? baseFormData,
    String? errMsg,
    UserInfoResponse? userInfo,
    PharmacyStoreResponse? pharmacyStore,
    @Default(false) bool isPharmacy,
    double? latitudeUser,
    double? longtitudeUser,
    double? latitudeStore,
    double? longtitudeStore,
  }) = _ProfileState;
}
