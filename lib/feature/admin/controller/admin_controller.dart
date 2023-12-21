import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';
import 'package:pharmacy_online/core/router/app_naviagor.dart';
import 'package:pharmacy_online/feature/admin/controller/state/admin_state.dart';
import 'package:pharmacy_online/feature/admin/model/request/approve_request.dart';
import 'package:pharmacy_online/feature/admin/usecase/get_pharmacy_detail_usecase.dart';
import 'package:pharmacy_online/feature/admin/usecase/update_approve_pharmacy_usecase.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';

final adminControllerProvider =
    StateNotifierProvider<AdminController, AdminState>(
  (ref) {
    final baseFormData = ref.watch(baseFormDataProvider);
    final baseUtils = ref.watch(baseUtilsProvider);
    final appNavigator = ref.watch(appNavigatorProvider);
    final getPharmacyDetailUsecase =
        ref.watch(getPharmacyDetailUsecaseProvider);
    final updateApprovePharmacyUsecase =
        ref.watch(updateApprovePharmacyUsecaseProvider);

    return AdminController(
      ref,
      const AdminState(),
      baseFormData,
      baseUtils,
      appNavigator,
      getPharmacyDetailUsecase,
      updateApprovePharmacyUsecase,
    );
  },
);

class AdminController extends StateNotifier<AdminState> {
  final Ref _ref;
  final BaseFormData _baseFormData;
  final LoaderController _loader;
  final BaseUtils _baseUtils;
  final AppNavigator _appNavigator;
  final GetPharmacyDetailUsecase _getPharmacyDetailUsecase;
  final UpdateApprovePharmacyUsecase _updateApprovePharmacyUsecase;

  AdminController(
    this._ref,
    AdminState state,
    this._baseFormData,
    this._baseUtils,
    this._appNavigator,
    this._getPharmacyDetailUsecase,
    this._updateApprovePharmacyUsecase,
  )   : _loader = _ref.read(loaderControllerProvider.notifier),
        super(state);

  Future<void> getPharmacyDetail() async {
    final result = await _getPharmacyDetailUsecase.execute(null);

    result.when((success) {
      state = state.copyWith(
        pharmacyInfoList: AsyncValue.data(success),
      );
    }, (error) => null);
  }

  Future<bool> updatePharmacyDetail(bool isApprove, String uid) async {
    bool isSuccess = false;
    _loader.onLoad();

    final result = await _updateApprovePharmacyUsecase.execute(
      ApproveRequest(isApprove: isApprove, uid: uid),
    );

    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }
}
