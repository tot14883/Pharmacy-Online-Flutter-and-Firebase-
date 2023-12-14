import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/router/app_naviagor.dart';
import 'package:pharmacy_online/feature/authentication/controller/state/authentication_state.dart';
import 'package:pharmacy_online/feature/authentication/enum/field_sign_up_enum.dart';
import 'package:pharmacy_online/feature/authentication/usecase/check_email_has_already_usecase.dart';

// import '../model/request/change_pass_request.dart';

final authenticationControllerProvider =
    StateNotifierProvider<AuthenticationController, AuthenticationState>(
  (ref) {
    final baseFormData = ref.watch(baseFormDataProvider);
    final baseSharePreference = ref.watch(baseSharePreferenceProvider);
    final appNavigator = ref.watch(appNavigatorProvider);
    final checkEmailHasAlreadyUsecase =
        ref.watch(checkEmailHasAlreadyUsecaseProvider);
    return AuthenticationController(
      ref,
      const AuthenticationState(),
      baseFormData,
      baseSharePreference,
      appNavigator,
      checkEmailHasAlreadyUsecase,
    );
  },
);

class AuthenticationController extends StateNotifier<AuthenticationState> {
  final Ref _ref;
  final BaseFormData _baseFormData;
  final LoaderController _loader;
  final BaseSharedPreference _baseSharePreference;
  final AppNavigator _appNavigator;
  final CheckEmailHasAlreadyUsecase _checkEmailHasAlreadyUsecase;

  AuthenticationController(
    this._ref,
    AuthenticationState state,
    this._baseFormData,
    this._baseSharePreference,
    this._appNavigator,
    this._checkEmailHasAlreadyUsecase,
  )   : _loader = _ref.read(loaderControllerProvider.notifier),
        super(state);

  void onChanged(BaseFormData baseFormData) {
    final newData = _baseFormData.copyAndMerge(baseFormData);
    state = state.copyWith(baseFormData: newData);
  }

  Future<bool> checkEmailHasAlready() async {
    bool isSuccess = false;
    final email = state.baseFormData?.getValue<String>(FieldSignUp.email);

    if (email != null && email.isNotEmpty) {
      final result = await _checkEmailHasAlreadyUsecase.execute(email);

      result.when((success) => isSuccess = success, (error) => null);
    }

    return isSuccess;
  }

  void clearForm() {
    state = state.copyWith(baseFormData: null);
  }
}
