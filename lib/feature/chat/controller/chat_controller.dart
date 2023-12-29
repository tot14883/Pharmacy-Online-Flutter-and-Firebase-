import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';
import 'package:pharmacy_online/core/router/app_naviagor.dart';
import 'package:pharmacy_online/feature/chat/controller/state/chat_state.dart';
import 'package:pharmacy_online/feature/chat/usecase/get_message_chat_usecase.dart';
import 'package:pharmacy_online/feature/chat/usecase/push_message_chat_usecase.dart';
import 'package:pharmacy_online/feature/store/model/request/chat_with_pharmacy_request.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';
import 'package:pharmacy_online/feature/store/usecase/get_chat_detail_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_history_of_chat_pharmacy_usecase.dart';
import 'package:pharmacy_online/feature/store/usecase/get_history_of_chat_user_usecase.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';

final chatControllerProvider = StateNotifierProvider<ChatController, ChatState>(
  (ref) {
    final baseFormData = ref.watch(baseFormDataProvider);
    final baseUtils = ref.watch(baseUtilsProvider);
    final appNavigator = ref.watch(appNavigatorProvider);
    final getHistoryOfChatUserUsecase =
        ref.watch(getHistoryOfChatUserUsecaseProvider);
    final getHistoryOfChatPharmacyUsecase =
        ref.watch(getHistoryOfChatPharmacyUsecaseProvider);
    final pushMessageChatUsecase = ref.watch(pushMessageChatUsecaseProvider);
    final getMessageChatUsecase = ref.watch(getMessageChatUsecaseProvider);
    final getChatDetailUsecase = ref.watch(getChatDetailUsecaseProvider);

    return ChatController(
      ref,
      const ChatState(),
      baseFormData,
      baseUtils,
      appNavigator,
      getHistoryOfChatUserUsecase,
      getHistoryOfChatPharmacyUsecase,
      pushMessageChatUsecase,
      getMessageChatUsecase,
      getChatDetailUsecase,
    );
  },
);

class ChatController extends StateNotifier<ChatState> {
  final Ref _ref;
  final BaseFormData _baseFormData;
  final LoaderController _loader;
  final BaseUtils _baseUtils;
  final AppNavigator _appNavigator;
  final GetHistoryOfChatUserUsecase _getHistoryOfChatUserUsecase;
  final GetHistoryOfChatPharmacyUsecase _getHistoryOfChatPharmacyUsecase;
  final PushMessageChatUsecase _pushMessageChatUsecase;
  final GetMessageChatUsecase _getMessageChatUsecase;
  final GetChatDetailUsecase _getChatDetailUsecase;

  ChatController(
    this._ref,
    ChatState state,
    this._baseFormData,
    this._baseUtils,
    this._appNavigator,
    this._getHistoryOfChatUserUsecase,
    this._getHistoryOfChatPharmacyUsecase,
    this._pushMessageChatUsecase,
    this._getMessageChatUsecase,
    this._getChatDetailUsecase,
  )   : _loader = _ref.read(loaderControllerProvider.notifier),
        super(state);

  void onChanged(BaseFormData baseFormData) {
    final newData = _baseFormData.copyAndMerge(baseFormData);
    state = state.copyWith(baseFormData: newData);
  }

  void clearForm() {
    state = state.copyWith(baseFormData: null);
  }

  Future<void> onGetHistoryOfChatUser() async {
    final result = await _getHistoryOfChatUserUsecase.execute(null);

    result.when(
      (success) => state =
          state.copyWith(chatWithPharmacyList: AsyncValue.data(success)),
      (error) => state =
          state.copyWith(chatWithPharmacyList: const AsyncValue.data([])),
    );
  }

  Future<void> onGetHistoryOfChatPharmacy() async {
    final result = await _getHistoryOfChatPharmacyUsecase.execute(null);

    result.when(
      (success) => state =
          state.copyWith(chatWithPharmacyList: AsyncValue.data(success)),
      (error) => state =
          state.copyWith(chatWithPharmacyList: const AsyncValue.data([])),
    );
  }

  Future<bool> onPushMessageChatUsecase(
    String id,
    String message,
    XFile? chatImg,
  ) async {
    bool isSuccess = false;
    final result = await _pushMessageChatUsecase.execute(
      ChatWithPharmacyRequest(
        id: id,
        message: message,
        chatImg: chatImg,
      ),
    );

    result.when((success) => isSuccess = success, (error) => null);

    return isSuccess;
  }

  Future<void> onGetMessageChatUsecase(String id) async {
    _loader.onLoad();
    state = state.copyWith(
      messageList: const AsyncValue.data(
        [],
      ),
    );

    final result = await _getMessageChatUsecase.execute(
      ChatWithPharmacyRequest(
        id: id,
      ),
    );

    result.when(
      (success) {
        state = state.copyWith(
          messageList: AsyncValue.data(success),
        );

        _loader.onDismissLoad();
      },
      (error) {
        state = state.copyWith(
          messageList: const AsyncValue.data(
            [],
          ),
        );
        _loader.onDismissLoad();
      },
    );
  }

  Future<void> onGetRealTimeMessageChatUsecase(String id) async {
    final result = await _getMessageChatUsecase.execute(
      ChatWithPharmacyRequest(
        id: id,
      ),
    );

    result.when(
      (success) {
        state = state.copyWith(
          messageList: AsyncValue.data(success),
        );
      },
      (error) {},
    );
  }

  Future<ChatWithPharmacyResponse> onGetChatDetail(
      String pharmacyId, String uid) async {
    ChatWithPharmacyResponse response = const ChatWithPharmacyResponse();

    final result = await _getChatDetailUsecase.execute(
      ChatWithPharmacyRequest(
        pharmacyId: pharmacyId,
        uid: uid,
      ),
    );

    result.when((success) => response = success, (error) => null);

    return response;
  }
}
