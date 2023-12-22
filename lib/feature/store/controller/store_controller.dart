import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';
import 'package:pharmacy_online/core/router/app_naviagor.dart';
import 'package:pharmacy_online/feature/store/controller/state/store_state.dart';
import 'package:pharmacy_online/feature/store/enum/field_medicine_enum.dart';
import 'package:pharmacy_online/feature/store/model/request/chat_with_pharmacy_request.dart';
import 'package:pharmacy_online/feature/store/model/request/medicine_request.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';
import 'package:pharmacy_online/feature/store/usecase/add_central_medicine_to_my_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/add_medicine_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/approve_chat_with_pharmacy_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/delete_medicine_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/edit_medicine_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_central_medicine_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_medicine_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_pharmacy_info_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_request_chat_with_pharmacy_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/request_chat_with_pharmacy_usecase.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';

final storeControllerProvider =
    StateNotifierProvider<StoreController, StoreState>(
  (ref) {
    final baseFormData = ref.watch(baseFormDataProvider);
    final baseUtils = ref.watch(baseUtilsProvider);
    final appNavigator = ref.watch(appNavigatorProvider);
    final addMedicineWarehouseUsecase =
        ref.watch(addMedicineWarehouseUsecaseProvider);
    final deleteMedicineWarehouseUsecase =
        ref.watch(deleteMedicineWarehouseUsecaseProvider);
    final editMedicineWarehouseUsecase =
        ref.watch(editMedicineWarehouseUsecaseProvider);
    final getCentralMedicineWarehouseUsecase =
        ref.watch(getCentralMedicineWarehouseUsecaseProvider);
    final getMedicineWarehouseUsecase =
        ref.watch(getMedicineWarehouseUsecaseProvider);
    final addCentralMedicineToMyWarehouseUsecase =
        ref.watch(addCentralMedicineToMyWarehouseUsecaseProvider);
    final getPharmacyInfoUsecase = ref.watch(getPharmacyInfoUsecaseProvider);
    final requestChatWithPharmacyUsecase =
        ref.watch(requestChatWithPharmacyUsecaseProvider);
    final getGetRequestChatWithPharmacyUsecase =
        ref.watch(getGetRequestChatWithPharmacyUsecaseProvider);
    final approveChatWithPharmacyUsecase =
        ref.watch(approveChatWithPharmacyUsecaseProvider);
    return StoreController(
      ref,
      const StoreState(),
      baseFormData,
      baseUtils,
      appNavigator,
      addMedicineWarehouseUsecase,
      deleteMedicineWarehouseUsecase,
      editMedicineWarehouseUsecase,
      getCentralMedicineWarehouseUsecase,
      getMedicineWarehouseUsecase,
      addCentralMedicineToMyWarehouseUsecase,
      getPharmacyInfoUsecase,
      requestChatWithPharmacyUsecase,
      getGetRequestChatWithPharmacyUsecase,
      approveChatWithPharmacyUsecase,
    );
  },
);

class StoreController extends StateNotifier<StoreState> {
  final Ref _ref;
  final BaseFormData _baseFormData;
  final LoaderController _loader;
  final BaseUtils _baseUtils;
  final AppNavigator _appNavigator;
  final AddMedicineWarehouseUsecase _addMedicineWarehouseUsecase;
  final DeleteMedicineWarehouseUsecase _deleteMedicineWarehouseUsecase;
  final EditMedicineWarehouseUsecase _editMedicineWarehouseUsecase;
  final GetCentralMedicineWarehouseUsecase _getCentralMedicineWarehouseUsecase;
  final GetMedicineWarehouseUsecase _getMedicineWarehouseUsecase;
  final AddCentralMedicineToMyWarehouseUsecase
      _addCentralMedicineToMyWarehouseUsecase;
  final GetPharmacyInfoUsecase _getPharmacyInfoUsecase;
  final RequestChatWithPharmacyUsecase _requestChatWithPharmacyUsecase;
  final GetRequestChatWithPharmacyUsecase _getGetRequestChatWithPharmacyUsecase;
  final ApproveChatWithPharmacyUsecase _approveChatWithPharmacyUsecase;

  StoreController(
    this._ref,
    StoreState state,
    this._baseFormData,
    this._baseUtils,
    this._appNavigator,
    this._addMedicineWarehouseUsecase,
    this._deleteMedicineWarehouseUsecase,
    this._editMedicineWarehouseUsecase,
    this._getCentralMedicineWarehouseUsecase,
    this._getMedicineWarehouseUsecase,
    this._addCentralMedicineToMyWarehouseUsecase,
    this._getPharmacyInfoUsecase,
    this._requestChatWithPharmacyUsecase,
    this._getGetRequestChatWithPharmacyUsecase,
    this._approveChatWithPharmacyUsecase,
  )   : _loader = _ref.read(loaderControllerProvider.notifier),
        super(state);

  void onChanged(BaseFormData baseFormData) {
    final newData = _baseFormData.copyAndMerge(baseFormData);
    state = state.copyWith(baseFormData: newData);
  }

  void clearForm() {
    state = state.copyWith(baseFormData: null);
  }

  Future<bool> addMedicineWarehouse(XFile medicineImg) async {
    _loader.onLoad();
    bool isSuccess = false;

    final baseFormData = state.baseFormData;
    final name = baseFormData?.getValue<String>(FieldMedicine.name);
    final price = baseFormData?.getValue<String>(FieldMedicine.price) ?? '0.0';

    final result = await _addMedicineWarehouseUsecase.execute(
      MedicineRequest(
        name: name,
        price: double.parse(price),
        medicineImg: medicineImg,
      ),
    );

    result.when(
      (success) {
        isSuccess = true;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

  Future<bool> editMedicineWarehouse(
    String id,
    XFile? medicineImg,
    String? currentMedicineImg,
  ) async {
    _loader.onLoad();
    bool isSuccess = false;

    final baseFormData = state.baseFormData;
    final name = baseFormData?.getValue<String>(FieldMedicine.name);
    final price = baseFormData?.getValue<String>(FieldMedicine.price) ?? '0.0';

    final result = await _editMedicineWarehouseUsecase.execute(
      MedicineRequest(
        id: id,
        name: name,
        price: double.parse(price),
        currentMedicineImg: currentMedicineImg,
        medicineImg: medicineImg,
      ),
    );

    result.when(
      (success) {
        isSuccess = true;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

  Future<bool> deleteMedicineWarehouse(String? id) async {
    bool isSuccess = false;

    final result = await _deleteMedicineWarehouseUsecase.execute(
      MedicineRequest(
        id: id,
      ),
    );

    result.when((success) => isSuccess = true, (error) => null);

    return isSuccess;
  }

  Future<void> onGetCentralMedicineWarehouse() async {
    state = state.copyWith(
      centralMedicineList: const AsyncValue.loading(),
    );
    final result = await _getCentralMedicineWarehouseUsecase.execute(null);

    result.when(
      (success) => state = state.copyWith(
        centralMedicineList: AsyncValue.data(success),
      ),
      (error) => state = state.copyWith(
        centralMedicineList: const AsyncValue.data([]),
      ),
    );
  }

  Future<void> onGetMedicineWarehouse() async {
    state = state.copyWith(
      medicineList: const AsyncValue.loading(),
    );
    final result = await _getMedicineWarehouseUsecase.execute(null);

    result.when(
      (success) => state = state.copyWith(
        medicineList: AsyncValue.data(success),
      ),
      (error) => state = state.copyWith(
        medicineList: const AsyncValue.data([]),
      ),
    );
  }

  Future<bool> onAddCentralMedicineToMyWarehouse(
      MedicineResponse medicineItem) async {
    _loader.onLoad();
    bool isSuccess = false;

    final result = await _addCentralMedicineToMyWarehouseUsecase.execute(
      MedicineRequest(
        id: medicineItem.id,
        name: medicineItem.name,
        price: medicineItem.price,
        currentMedicineImg: medicineItem.medicineImg,
      ),
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

  Future<void> getPharmacyInfo() async {
    final result = await _getPharmacyInfoUsecase.execute(null);

    result.when(
      (success) => state = state.copyWith(
        pharmacyInfoList: AsyncValue.data(success),
      ),
      (error) => null,
    );

    final myLocation = await _ref.read(baseUtilsProvider).getLocation();
    myLocation.when(
      (success) {
        state = state.copyWith(
          myLatitude: success.latitude,
          myLongtitude: success.longitude,
        );
      },
      (error) => null,
    );
  }

  Future<bool> onRequestChatWithPharmacy(String pharmacyId) async {
    bool isSuccess = false;
    _loader.onLoad();

    final result = await _requestChatWithPharmacyUsecase.execute(
      ChatWithPharmacyRequest(
        pharmacyId: pharmacyId,
      ),
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

  Future<void> onGetGetRequestChatWithPharmacy() async {
    final result = await _getGetRequestChatWithPharmacyUsecase.execute(null);

    result.when(
      (success) {
        state = state.copyWith(
          chatWithPharmacyList: AsyncValue.data(success),
        );
      },
      (error) => state = state.copyWith(
        chatWithPharmacyList: const AsyncValue.data([]),
      ),
    );
  }

  Future<bool> onApproveChatWithPharmacy(
    bool isApprove,
    String id,
  ) async {
    _loader.onLoad();
    bool isSuccess = false;

    final result = await _approveChatWithPharmacyUsecase.execute(
      ChatWithPharmacyRequest(
        isApprove: isApprove,
        id: id,
      ),
    );

    result.when(
      (success) {
        _loader.onDismissLoad();
        isSuccess = success;
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }
}
