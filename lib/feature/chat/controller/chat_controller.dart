import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';
import 'package:pharmacy_online/core/router/app_naviagor.dart';
import 'package:pharmacy_online/feature/chat/controller/state/chat_state.dart';
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

    return ChatController(
      ref,
      const ChatState(),
      baseFormData,
      baseUtils,
      appNavigator,
      getHistoryOfChatUserUsecase,
      getHistoryOfChatPharmacyUsecase,
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

  ChatController(
    this._ref,
    ChatState state,
    this._baseFormData,
    this._baseUtils,
    this._appNavigator,
    this._getHistoryOfChatUserUsecase,
    this._getHistoryOfChatPharmacyUsecase,
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
}
