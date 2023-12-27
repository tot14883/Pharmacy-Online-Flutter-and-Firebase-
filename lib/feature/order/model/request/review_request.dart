import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_request.freezed.dart';
part 'review_request.g.dart';

@immutable
@freezed
abstract class ReviewRequest with _$ReviewRequest {
  @JsonSerializable()
  const factory ReviewRequest({
    String? reviewId,
    String? storeId,
    double? rating,
    String? pharmacyId,
    String? uid,
    String? message,
    String? orderId,
  }) = _ReviewRequest;

  factory ReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$ReviewRequestFromJson(json);
}
