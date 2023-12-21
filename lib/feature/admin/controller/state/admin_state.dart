import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';

part 'admin_state.freezed.dart';

@freezed
class AdminState with _$AdminState {
  const factory AdminState({
    @Default(AsyncValue.loading())
    AsyncValue<List<PharmacyInfoResponse>?> pharmacyInfoList,
  }) = _AdminState;
}
