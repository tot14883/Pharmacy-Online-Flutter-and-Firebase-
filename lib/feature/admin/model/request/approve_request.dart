import 'package:freezed_annotation/freezed_annotation.dart';

part 'approve_request.freezed.dart';
part 'approve_request.g.dart';

@immutable
@freezed
abstract class ApproveRequest with _$ApproveRequest {
  @JsonSerializable()
  const factory ApproveRequest({
    required bool isApprove,
    required String uid,
  }) = _ApproveRequest;

  factory ApproveRequest.fromJson(Map<String, dynamic> json) =>
      _$ApproveRequestFromJson(json);
}
