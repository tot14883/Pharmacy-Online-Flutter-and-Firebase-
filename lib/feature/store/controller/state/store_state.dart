import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';

part 'store_state.freezed.dart';

@freezed
class StoreState with _$StoreState {
  const factory StoreState({
    BaseFormData? baseFormData,
    String? errMsg,
    @Default(AsyncValue.loading())
    AsyncValue<List<MedicineResponse>?> centralMedicineList,
    @Default(AsyncValue.loading())
    AsyncValue<List<MedicineResponse>?> medicineList,
  }) = _StoreState;
}
