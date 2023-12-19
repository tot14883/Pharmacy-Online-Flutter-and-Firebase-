import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/router/app_naviagor.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/authentication/model/request/user_info_request.dart';
import 'package:pharmacy_online/feature/authentication/usecase/update_pharmacy_store_usecase.dart';
import 'package:pharmacy_online/feature/authentication/usecase/update_user_info_usecase.dart';
import 'package:pharmacy_online/feature/profile/controller/state/profile_state.dart';
import 'package:pharmacy_online/feature/profile/enum/field_user_info_enum.dart';
import 'package:pharmacy_online/feature/profile/usecase/get_pharmacy_store_usecase.dart';
import 'package:pharmacy_online/feature/profile/usecase/get_user_info_usecase.dart';

// import '../model/request/change_pass_request.dart';

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>(
  (ref) {
    final baseFormData = ref.watch(baseFormDataProvider);
    final baseSharePreference = ref.watch(baseSharePreferenceProvider);
    final appNavigator = ref.watch(appNavigatorProvider);
    final getUserInfoUsecase = ref.watch(getUserInfoUsecaseProvider);
    final getPharmacyUsecase = ref.watch(getPharmacyUsecaseProvider);
    final updateUserInfoUsecase = ref.watch(updateUserInfoUsecaseProvider);
    final updatePharmacyStoreUsecase =
        ref.watch(updatePharmacyStoreUsecaseProvider);

    return ProfileController(
      ref,
      const ProfileState(),
      baseFormData,
      baseSharePreference,
      appNavigator,
      getUserInfoUsecase,
      getPharmacyUsecase,
      updateUserInfoUsecase,
      updatePharmacyStoreUsecase,
    );
  },
);

class ProfileController extends StateNotifier<ProfileState> {
  final Ref _ref;
  final BaseFormData _baseFormData;
  final LoaderController _loader;
  final BaseSharedPreference _baseSharePreference;
  final AppNavigator _appNavigator;
  final GetUserInfoUseCase _getUserInfoUsecase;
  final GetPharmacyUseCase _getPharmacyUsecase;
  final UpdateUserInfoUsecase _updateUserInfoUsecase;
  final UpdatePharmacyStoreUsecase _updatePharmacyStoreUsecase;

  ProfileController(
    this._ref,
    ProfileState state,
    this._baseFormData,
    this._baseSharePreference,
    this._appNavigator,
    this._getUserInfoUsecase,
    this._getPharmacyUsecase,
    this._updateUserInfoUsecase,
    this._updatePharmacyStoreUsecase,
  )   : _loader = _ref.read(loaderControllerProvider.notifier),
        super(state);

  void onChanged(BaseFormData baseFormData) {
    final newData = _baseFormData.copyAndMerge(baseFormData);
    state = state.copyWith(baseFormData: newData);
  }

  void setLatAndLongUser(double latitude, double longtitude) {
    state = state.copyWith(
      latitudeUser: latitude,
      longtitudeUser: longtitude,
    );
  }

  void setLatAndLongPharmacyStore(double latitude, double longtitude) {
    state = state.copyWith(
      latitudeStore: latitude,
      longtitudeStore: longtitude,
    );
  }

  Future<void> onGetUserInfo() async {
    _loader.onLoad();
    final result = await _getUserInfoUsecase.execute(null);

    result.when(
      (success) {
        state = state.copyWith(
          userInfo: success,
          isPharmacy: success.role == AuthenticationType.pharmacy.name,
        );

        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );
  }

  Future<void> onGetPharmacyStore() async {
    _loader.onLoad();

    final result = await _getPharmacyUsecase.execute(null);

    result.when(
      (success) {
        state = state.copyWith(
          pharmacyStore: success,
        );
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );
  }

  void onUpdateUserInfo(
    XFile? imgProfile,
  ) async {
    _loader.onLoad();

    final baseFormData = state.baseFormData;
    final email = baseFormData?.getValue<String>(FieldUserInfo.email) ?? '';
    final password =
        baseFormData?.getValue<String>(FieldUserInfo.password) ?? '';
    final fullName = baseFormData?.getValue<String>(FieldUserInfo.name) ?? '';
    final phone = baseFormData?.getValue<String>(FieldUserInfo.phone) ?? '';
    final address = baseFormData?.getValue<String>(FieldUserInfo.address);

    await _updateUserInfoUsecase.execute(
      UserInfoRequest(
        email: email,
        password: password,
        fullName: fullName,
        phone: phone,
        address: address,
        latitude: state.latitudeStore ?? state.latitudeUser,
        longtitude: state.longtitudeStore ?? state.longtitudeUser,
        profileImg: imgProfile,
        currentProfileImg: state.userInfo?.profileImg ?? '',
      ),
    );

    await onGetUserInfo();
  }

  void onUpdatePharmacyStore(
    XFile? licensePharmacyImg,
    XFile? licensePharmacyStoreImg,
    XFile? qrCodeImg,
    XFile? store,
  ) async {
    _loader.onLoad();

    final baseFormData = state.baseFormData;

    // Pharmacy & Store
    final nameStore =
        baseFormData?.getValue<String>(FieldUserInfo.nameStore) ?? '';
    final addressStore =
        baseFormData?.getValue<String>(FieldUserInfo.addressStore) ?? '';
    final phoneStore =
        baseFormData?.getValue<String>(FieldUserInfo.phoneStore) ?? '';
    final timeOpening =
        baseFormData?.getValue<String>(FieldUserInfo.timeOpening) ?? '';
    final timeClosing =
        baseFormData?.getValue<String>(FieldUserInfo.timeClosing) ?? '';
    final licensePharmacy =
        baseFormData?.getValue<String>(FieldUserInfo.licensePharmacy) ?? '';
    final licensePharmacyStore =
        baseFormData?.getValue<String>(FieldUserInfo.licensePharmacyStore) ??
            '';

    await _updatePharmacyStoreUsecase.execute(
      UserInfoRequest(
        address: addressStore,
        latitude: state.latitudeStore ?? state.latitudeUser,
        longtitude: state.longtitudeStore ?? state.longtitudeUser,
        nameStore: nameStore,
        phoneStore: phoneStore,
        timeOpening: timeOpening,
        timeClosing: timeClosing,
        licensePharmacy: licensePharmacy,
        licenseStore: licensePharmacyStore,
        licensePharmacyImg: licensePharmacyImg,
        storeImg: store,
        licenseStoreImg: licensePharmacyStoreImg,
        qrCodeImg: qrCodeImg,
        currentLicensePharmacyImg:
            state.pharmacyStore?.licensePharmacyImg ?? '',
        currentLicenseStoreImg: state.pharmacyStore?.licenseStoreImg ?? '',
        currentQrCodeImg: state.pharmacyStore?.qrCodeImg ?? '',
        currentStoreImg: state.pharmacyStore?.storeImg ?? '',
      ),
    );

    await onGetPharmacyStore();
  }
}
