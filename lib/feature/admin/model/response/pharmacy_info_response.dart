import 'package:freezed_annotation/freezed_annotation.dart';

part 'pharmacy_info_response.freezed.dart';
part 'pharmacy_info_response.g.dart';

@immutable
@freezed
abstract class PharmacyInfoResponse with _$PharmacyInfoResponse {
  @JsonSerializable()
  const factory PharmacyInfoResponse({
    String? uid,
    String? email,
    String? password,
    String? role,
    String? profileImg,
    String? fullName,
    String? address,
    String? licensePharmacy,
    String? licensePharmacyImg,
    String? phone,
    String? addressStore,
    String? storeImg,
    String? nameStore,
    String? phoneStore,
    String? timeOpening,
    String? timeClosing,
    String? licenseStore,
    String? licenseStoreImg,
    String? status,
  }) = _PharmacyInfoResponse;

  factory PharmacyInfoResponse.fromJson(Map<String, dynamic> json) =>
      _$PharmacyInfoResponseFromJson(json);
}
