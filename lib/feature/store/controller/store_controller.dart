import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/router/app_naviagor.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/order/model/request/review_request.dart';
import 'package:pharmacy_online/feature/store/controller/state/store_state.dart';
import 'package:pharmacy_online/feature/store/enum/field_medicine_enum.dart';
import 'package:pharmacy_online/feature/store/model/request/chat_with_pharmacy_request.dart';
import 'package:pharmacy_online/feature/store/model/request/comment_request.dart';
import 'package:pharmacy_online/feature/store/model/request/medicine_request.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';
import 'package:pharmacy_online/feature/store/usecase/add_central_medicine_to_my_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/add_comment_store_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/add_medicine_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/add_review_store_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/approve_chat_with_pharmacy_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/check_request_chat_already_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/check_request_chat_waiting_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/delete_comment_store_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/delete_medicine_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/delete_review_store_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/edit_comment_store_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/edit_medicine_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/edit_review_store_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_central_medicine_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_comment_store_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_medicine_warehouse_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_pharmacy_detail_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_pharmacy_info_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_request_chat_with_pharmacy_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_review_store_usecase.dart';
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
    final getPharmacyDetailUsecase =
        ref.watch(getPharmacyDetailUsecaseProvider);
    final getReviewStoreUsecase = ref.watch(getReviewStoreUsecaseProvider);
    final getCommentStoreUsecase = ref.watch(getCommentStoreUsecaseProvider);
    final addReviewStoreUsecase = ref.watch(addReviewStoreUsecaseProvider);
    final addCommentStoreUsecase = ref.watch(addCommentStoreUsecaseProvider);
    final editReviewStoreUsecase = ref.watch(editReviewStoreUsecaseProvider);
    final editCommentStoreUsecase = ref.watch(editCommentStoreUsecaseProvider);
    final deleteReviewStoreUsecase =
        ref.watch(deleteReviewStoreUsecaseProvider);
    final deleteCommentStoreUsecase =
        ref.watch(deleteCommentStoreUsecaseProvider);
    final checkRequestChatAlreadyUsecase =
        ref.watch(checkRequestChatAlreadyUsecaseProvider);
    final checkRequestChatWaitingUsecase =
        ref.watch(checkRequestChatWaitingUsecaseProvider);
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
      getPharmacyDetailUsecase,
      getReviewStoreUsecase,
      getCommentStoreUsecase,
      addReviewStoreUsecase,
      addCommentStoreUsecase,
      editReviewStoreUsecase,
      editCommentStoreUsecase,
      deleteReviewStoreUsecase,
      deleteCommentStoreUsecase,
      checkRequestChatAlreadyUsecase,
      checkRequestChatWaitingUsecase,
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
  final GetPharmacyDetailUsecase _getPharmacyDetailUsecase;
  final GetReviewStoreUsecase _getReviewStoreUsecase;
  final GetCommentStoreUsecase _getCommentStoreUsecase;
  final AddReviewStoreUsecase _addReviewStoreUsecase;
  final AddCommentStoreUsecase _addCommentStoreUsecase;
  final EditReviewStoreUsecase _editReviewStoreUsecase;
  final EditCommentStoreUsecase _editCommentStoreUsecase;
  final DeleteReviewStoreUsecase _deleteReviewStoreUsecase;
  final DeleteCommentStoreUsecase _deleteCommentStoreUsecase;
  final CheckRequestChatAlreadyUsecase _checkRequestChatAlreadyUsecase;
  final CheckRequestChatWaitingUsecase _checkRequestChatWaitingUsecase;

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
    this._getPharmacyDetailUsecase,
    this._getReviewStoreUsecase,
    this._getCommentStoreUsecase,
    this._addReviewStoreUsecase,
    this._addCommentStoreUsecase,
    this._editReviewStoreUsecase,
    this._editCommentStoreUsecase,
    this._deleteReviewStoreUsecase,
    this._deleteCommentStoreUsecase,
    this._checkRequestChatAlreadyUsecase,
    this._checkRequestChatWaitingUsecase,
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

    final isAdmin = _ref
            .read(baseSharePreferenceProvider)
            .getString(BaseSharePreferenceKey.role) ==
        AuthenticationType.admin.name;

    final result = await _addMedicineWarehouseUsecase.execute(
      MedicineRequest(
        name: name,
        price: double.parse(isAdmin ? '0.0' : price),
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

  Future<void> onGetPharmacyDetail(String pharmacyId) async {
    final result = await _getPharmacyDetailUsecase.execute(pharmacyId);

    result.when(
      (success) =>
          state = state.copyWith(pharmacyDetail: AsyncValue.data(success)),
      (error) => state = state.copyWith(
        pharmacyDetail: const AsyncValue.data(null),
      ),
    );
  }

  Future<void> onGetReview(
    String pharmacyId,
  ) async {
    final result = await _getReviewStoreUsecase.execute(
      ReviewRequest(pharmacyId: pharmacyId),
    );

    result.when(
      (success) {
        state = state.copyWith(reviewList: AsyncValue.data(success));
      },
      (error) => state = state.copyWith(
        reviewList: const AsyncValue.data(null),
      ),
    );
  }

  Future<void> onGetComment(
    String reviewId,
  ) async {
    final result = await _getCommentStoreUsecase.execute(
      CommentRequest(reviewId: reviewId),
    );

    result.when(
      (success) {
        state = state.copyWith(commentList: AsyncValue.data(success));
      },
      (error) => state = state.copyWith(
        commentList: const AsyncValue.data(null),
      ),
    );
  }

  Future<bool> onAddReview(
    String orderId,
    String pharmacyId,
    String uid,
    String message,
    double rating,
  ) async {
    _loader.onLoad();
    bool isSuccess = false;

    if (message.isEmpty) {
      return true;
    }

    final result = await _addReviewStoreUsecase.execute(
      ReviewRequest(
        orderId: orderId,
        pharmacyId: pharmacyId,
        uid: uid,
        message: message,
        rating: rating,
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

  Future<bool> onAddComment(
    String reviewId,
    String pharmacyId,
    String uid,
    String message,
  ) async {
    _loader.onLoad();
    bool isSuccess = false;

    final result = await _addCommentStoreUsecase.execute(
      CommentRequest(
        reviewId: reviewId,
        pharmacyId: pharmacyId,
        uid: uid,
        message: message,
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

  Future<bool> onEditReview(
    String reviewId,
    double rating,
    String message,
  ) async {
    _loader.onLoad();
    bool isSuccess = false;

    final result = await _editReviewStoreUsecase.execute(
      ReviewRequest(
        reviewId: reviewId,
        rating: rating,
        message: message,
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

  Future<bool> onEditComment(
    String reviewId,
    String commentId,
    String message,
  ) async {
    _loader.onLoad();
    bool isSuccess = false;

    final result = await _editCommentStoreUsecase.execute(
      CommentRequest(
        reviewId: reviewId,
        commentId: commentId,
        message: message,
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

  Future<bool> onDeleteReview(
    String reviewId,
  ) async {
    _loader.onLoad();
    bool isSuccess = false;

    final result = await _deleteReviewStoreUsecase.execute(
      CommentRequest(
        reviewId: reviewId,
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

  Future<bool> onDeleteComment(
    String reviewId,
    String commentId,
  ) async {
    _loader.onLoad();
    bool isSuccess = false;

    final result = await _deleteCommentStoreUsecase.execute(
      CommentRequest(
        reviewId: reviewId,
        commentId: commentId,
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

  Future<void> onCheckRequestChatAlready(String pharmacyId) async {
    final result = await _checkRequestChatAlreadyUsecase.execute(
      ChatWithPharmacyRequest(
        pharmacyId: pharmacyId,
      ),
    );

    result.when(
      (success) => state = state.copyWith(
        checkRequestChatAlready: success,
      ),
      (error) => null,
    );
  }

  Future<void> onCheckRequestChatWaiting(String pharmacyId) async {
    final result = await _checkRequestChatWaitingUsecase.execute(
      ChatWithPharmacyRequest(
        pharmacyId: pharmacyId,
      ),
    );

    result.when(
      (success) => state = state.copyWith(
        checkRequestChatWaiting: success,
      ),
      (error) => null,
    );
  }
}
