import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_request.freezed.dart';
part 'change_password_request.g.dart';

@immutable
@freezed
class ChangePasswordRequest with _$ChangePasswordRequest {
  const factory ChangePasswordRequest({
    required String currentPassword,
    required String newPassword,
  }) = _ChangePasswordRequest;

  factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordRequestFromJson(json);
}
