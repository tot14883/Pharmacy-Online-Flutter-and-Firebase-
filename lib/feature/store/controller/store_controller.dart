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

//riverpod ดึงข้อมูลจาก usecase มาใช้
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

// เมธอดสำหรับอัปเดตสถานะเมื่อข้อมูลในฟอร์มเปลี่ยนแปลง
  void onChanged(BaseFormData baseFormData) {
    // สร้างสำเนาของข้อมูลฟอร์มปัจจุบันและผสานกับข้อมูลที่เข้ามาใหม่
    final newData = _baseFormData.copyAndMerge(baseFormData);
    // อัปเดตสถานะโดยแทนที่ข้อมูลฟอร์มด้วยข้อมูลที่ผสานแล้ว
    state = state.copyWith(baseFormData: newData);
  }

// เมธอดสำหรับล้างข้อมูลในฟอร์ม
  void clearForm() {
    state = state.copyWith(baseFormData: null);
  }

// เมธอดสำหรับเพิ่มยาในคลังยา
  Future<bool> addMedicineWarehouse(XFile medicineImg) async {
    _loader.onLoad(); // แสดง loading indicator
    bool isSuccess = false;

    // ดึงข้อมูลยาจากสถานะปัจจุบัน
    final baseFormData = state.baseFormData;

    final name = baseFormData?.getValue<String>(FieldMedicine.name);

    final price = baseFormData?.getValue<String>(FieldMedicine.price) ?? '0.0';

    // ตรวจสอบว่าผู้ใช้เป็น admin หรือไม่
    final isAdmin = _ref
            .read(baseSharePreferenceProvider)
            .getString(BaseSharePreferenceKey.role) ==
        AuthenticationType.admin.name;

    // เรียกใช้ usecase เพื่อเพิ่มยาในคลังยา
    final result = await _addMedicineWarehouseUsecase.execute(
      MedicineRequest(
        name: name,
        price: double.parse(
            isAdmin ? '0.0' : price), // หากเป็น admin ให้ราคาเป็น 0
        medicineImg: medicineImg,
      ),
    );

    // จัดการผลลัพธ์ของการเรียกใช้ usecase
    result.when(
      (success) {
        isSuccess = true;
        _loader.onDismissLoad(); // ปิด loading indicator
      },
      (error) =>
          _loader.onDismissLoad(), // ปิด loading indicator เมื่อเกิดข้อผิดพลาด
    );

    return isSuccess;
  }

// เมธอดสำหรับแก้ไขข้อมูลยาในคลังยา
  Future<bool> editMedicineWarehouse(
    String id,
    XFile? medicineImg,
    String? currentMedicineImg,
  ) async {
    _loader.onLoad(); // แสดง loading indicator
    bool isSuccess = false;

    // ดึงข้อมูลยาจากสถานะปัจจุบัน
    final baseFormData = state.baseFormData;
    final name = baseFormData?.getValue<String>(FieldMedicine.name);
    final price = baseFormData?.getValue<String>(FieldMedicine.price) ?? '0.0';

    // เรียกใช้ usecase เพื่อแก้ไขข้อมูลยา
    final result = await _editMedicineWarehouseUsecase.execute(
      MedicineRequest(
        id: id,
        name: name,
        price: double.parse(price),
        currentMedicineImg: currentMedicineImg,
        medicineImg: medicineImg,
      ),
    );

    // จัดการผลลัพธ์ของการเรียกใช้ usecase
    result.when(
      (success) {
        isSuccess = true;
        _loader.onDismissLoad(); // ปิด loading indicator
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับลบยาออกจากคลังยา
  Future<bool> deleteMedicineWarehouse(String? id) async {
    bool isSuccess = false;

    // เรียกใช้ usecase เพื่อลบยา
    final result = await _deleteMedicineWarehouseUsecase.execute(
      MedicineRequest(
        id: id,
      ),
    );

    // จัดการผลลัพธ์ของการเรียกใช้ usecase
    result.when((success) => isSuccess = true, (error) => null);

    return isSuccess;
  }

// เมธอดสำหรับดึงข้อมูลยาจากคลังกลาง
  Future<void> onGetCentralMedicineWarehouse() async {
    state = state.copyWith(
      centralMedicineList: const AsyncValue.loading(), // แสดงสถานะ loading
    );
    final result = await _getCentralMedicineWarehouseUsecase.execute(null);

    result.when(
      (success) => state = state.copyWith(
        centralMedicineList:
            AsyncValue.data(success), // แสดงข้อมูลยาที่ดึงมาได้
      ),
      (error) => state = state.copyWith(
        centralMedicineList:
            const AsyncValue.data([]), // แสดงข้อมูลว่างเมื่อเกิดข้อผิดพลาด
      ),
    );
  }

// เมธอดสำหรับดึงข้อมูลยาจากคลังยาของผู้ใช้
  Future<void> onGetMedicineWarehouse() async {
    state = state.copyWith(
      medicineList: const AsyncValue.loading(), // แสดงสถานะ loading
    );
    final result = await _getMedicineWarehouseUsecase.execute(null);

    result.when(
      (success) => state = state.copyWith(
        medicineList: AsyncValue.data(success), // แสดงข้อมูลยาที่ดึงมาได้
      ),
      (error) => state = state.copyWith(
        medicineList:
            const AsyncValue.data([]), // แสดงข้อมูลว่างเมื่อเกิดข้อผิดพลาด
      ),
    );
  }

// เมธอดสำหรับเพิ่มยาจากคลังกลางไปยังคลังยาของผู้ใช้
  Future<bool> onAddCentralMedicineToMyWarehouse(
      MedicineResponse medicineItem) async {
    _loader.onLoad(); // แสดง loading indicator
    bool isSuccess = false;

    // เรียกใช้ usecase เพื่อเพิ่มยา
    final result = await _addCentralMedicineToMyWarehouseUsecase.execute(
      MedicineRequest(
        id: medicineItem.id,
        name: medicineItem.name,
        price: medicineItem.price,
        currentMedicineImg: medicineItem.medicineImg,
      ),
    );

    // จัดการผลลัพธ์ของการเรียกใช้ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad(); // ปิด loading indicator
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับดึงข้อมูลร้านขายยาและตำแหน่งปัจจุบันของผู้ใช้
  Future<void> getPharmacyInfo() async {
    // เรียกใช้ usecase เพื่อดึงข้อมูลร้านขายยา
    final result = await _getPharmacyInfoUsecase.execute(null);

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) => state = state.copyWith(
        pharmacyInfoList: AsyncValue.data(success), // เก็บข้อมูลร้านยา
      ),
      (error) => null,
    );

    // ดึงตำแหน่งปัจจุบันของผู้ใช้
    final myLocation = await _ref.read(baseUtilsProvider).getLocation();
    myLocation.when(
      (success) {
        state = state.copyWith(
          myLatitude: success.latitude,
          myLongtitude: success.longitude,
        ); // เก็บพิกัด
      },
      (error) => null,
    );
  }

// เมธอดสำหรับส่งคำขอแชทกับร้านขายยา
  Future<bool> onRequestChatWithPharmacy(String pharmacyId) async {
    bool isSuccess = false;
    _loader.onLoad(); // แสดง loading indicator

    // เรียกใช้ usecase เพื่อส่งคำขอแชท
    final result = await _requestChatWithPharmacyUsecase.execute(
      ChatWithPharmacyRequest(
        pharmacyId: pharmacyId,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(), // ปิด loading indicator
    );

    return isSuccess;
  }

// เมธอดสำหรับดึงคำขอแชทที่ผู้ใช้ได้รับ
  Future<void> onGetGetRequestChatWithPharmacy() async {
    final result = await _getGetRequestChatWithPharmacyUsecase.execute(null);

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        state = state.copyWith(
          chatWithPharmacyList: AsyncValue.data(success), // เก็บข้อมูลคำขอแชท
        );
      },
      (error) => state = state.copyWith(
        chatWithPharmacyList:
            const AsyncValue.data([]), // แสดงข้อมูลว่างเมื่อเกิดข้อผิดพลาด
      ),
    );
  }

// เมธอดสำหรับอนุมัติหรือปฏิเสธคำขอแชท
  Future<bool> onApproveChatWithPharmacy(
    bool isApprove,
    String id,
  ) async {
    _loader.onLoad(); // แสดง loading indicator
    bool isSuccess = false;

    final result = await _approveChatWithPharmacyUsecase.execute(
      ChatWithPharmacyRequest(
        isApprove: isApprove,
        id: id,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        _loader.onDismissLoad();
        isSuccess = success;
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับดึงข้อมูลรายละเอียดร้านขายยา
  Future<void> onGetPharmacyDetail(String pharmacyId) async {
    final result = await _getPharmacyDetailUsecase.execute(pharmacyId);

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) =>
          state = state.copyWith(pharmacyDetail: AsyncValue.data(success)),
      (error) => state = state.copyWith(
        pharmacyDetail: const AsyncValue.data(null),
      ),
    );
  }

// เมธอดสำหรับดึงข้อมูลรีวิวของร้านขายยา
  Future<void> onGetReview(
    String pharmacyId,
  ) async {
    final result = await _getReviewStoreUsecase.execute(
      ReviewRequest(pharmacyId: pharmacyId),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        state = state.copyWith(reviewList: AsyncValue.data(success));
      },
      (error) => state = state.copyWith(
        reviewList: const AsyncValue.data(null),
      ),
    );
  }

// เมธอดสำหรับดึงข้อมูลคอมเมนต์ของรีวิว
  Future<void> onGetComment(
    String reviewId,
  ) async {
    final result = await _getCommentStoreUsecase.execute(
      CommentRequest(reviewId: reviewId),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        state = state.copyWith(commentList: AsyncValue.data(success));
      },
      (error) => state = state.copyWith(
        commentList: const AsyncValue.data(null),
      ),
    );
  }

// เมธอดสำหรับเพิ่มรีวิวร้านขายยา
  Future<bool> onAddReview(
    String orderId,
    String pharmacyId,
    String uid,
    String message,
    double rating,
  ) async {
    _loader.onLoad(); // แสดง loading indicator
    bool isSuccess = false;

    if (message.isEmpty) {
      // ข้ามการเรียกใช้ usecase หากข้อความรีวิวว่าง
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

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับเพิ่มคอมเมนต์ใต้รีวิว
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

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับแก้ไขรีวิวร้านขายยา
  Future<bool> onEditReview(
    String reviewId,
    double rating,
    String message,
  ) async {
    _loader.onLoad();
    bool isSuccess = false;

    // เรียกใช้ usecase เพื่อแก้ไขรีวิว
    final result = await _editReviewStoreUsecase.execute(
      ReviewRequest(
        reviewId: reviewId,
        rating: rating,
        message: message,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับแก้ไขคอมเมนต์ใต้รีวิว
  Future<bool> onEditComment(
    String reviewId,
    String commentId,
    String message,
  ) async {
    _loader.onLoad(); // แสดง loading indicator
    bool isSuccess = false;

    // เรียกใช้ usecase เพื่อแก้ไขคอมเมนต์
    final result = await _editCommentStoreUsecase.execute(
      CommentRequest(
        reviewId: reviewId,
        commentId: commentId,
        message: message,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad(); // ปิด loading indicator
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับลบรีวิวร้านขายยา
  Future<bool> onDeleteReview(
    String reviewId,
  ) async {
    _loader.onLoad(); // แสดง loading indicator
    bool isSuccess = false;

    final result = await _deleteReviewStoreUsecase.execute(
      CommentRequest(
        reviewId: reviewId,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับลบคอมเมนต์ใต้รีวิว
  Future<bool> onDeleteComment(
    String reviewId,
    String commentId,
  ) async {
    _loader.onLoad();
    bool isSuccess = false;

    // เรียกใช้ usecase เพื่อลบคอมเมนต์
    final result = await _deleteCommentStoreUsecase.execute(
      CommentRequest(
        reviewId: reviewId,
        commentId: commentId,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

// เมธอดสำหรับตรวจสอบว่ามีคำขอแชทกับร้านขายยานี้อยู่แล้วหรือไม่
  Future<void> onCheckRequestChatAlready(String pharmacyId) async {
    final result = await _checkRequestChatAlreadyUsecase.execute(
      ChatWithPharmacyRequest(
        pharmacyId: pharmacyId,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      (success) => state = state.copyWith(
        checkRequestChatAlready: success,
      ),
      (error) => null,
    );
  }

// เมธอดสำหรับตรวจสอบว่ามีคำขอแชทกับร้านขายยานี้ที่รอการอนุมัติหรือไม่
  Future<void> onCheckRequestChatWaiting(String pharmacyId) async {
    // เรียกใช้ usecase เพื่อตรวจสอบ
    final result = await _checkRequestChatWaitingUsecase.execute(
      ChatWithPharmacyRequest(
        pharmacyId: pharmacyId,
      ),
    );

    // จัดการผลลัพธ์ของ usecase
    result.when(
      // หากสำเร็จ เก็บข้อมูลผลลัพธ์ลงใน state
      (success) => state = state.copyWith(
        checkRequestChatWaiting: success,
      ),
      (error) => null,
    );
  }
}
