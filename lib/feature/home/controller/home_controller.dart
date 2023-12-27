import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';
import 'package:pharmacy_online/feature/home/controller/state/home_state.dart';
import 'package:pharmacy_online/feature/home/model/request/notification_request.dart';
import 'package:pharmacy_online/feature/home/usecase/delete_notification_usecase.dart';
import 'package:pharmacy_online/feature/home/usecase/get_notification_usecase.dart';
import 'package:pharmacy_online/feature/home/usecase/post_notification_usecase.dart';
import 'package:pharmacy_online/feature/home/usecase/update_notification_usecase.dart';

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) {
    final getNotificationUsecase = ref.watch(getNotificationUsecaseProvider);
    final postNotificationUsecase = ref.watch(postNotificationUsecaseProvider);
    final deleteNotificationUsecase =
        ref.watch(deleteNotificationUsecaseProvider);
    final updateNotificationUsecase =
        ref.watch(updateNotificationUsecaseProvider);

    return HomeController(
      ref,
      const HomeState(),
      getNotificationUsecase,
      postNotificationUsecase,
      deleteNotificationUsecase,
      updateNotificationUsecase,
    );
  },
);

class HomeController extends StateNotifier<HomeState> {
  final Ref _ref;
  final LoaderController _loader;
  final GetNotificationUsecase _getNotificationUsecase;
  final PostNotificationUsecase _postNotificationUsecase;
  final DeleteNotificationUsecase _deleteNotificationUsecase;
  final UpdateNotificationUsecase _updateNotificationUsecase;

  HomeController(
    this._ref,
    HomeState state,
    this._getNotificationUsecase,
    this._postNotificationUsecase,
    this._deleteNotificationUsecase,
    this._updateNotificationUsecase,
  )   : _loader = _ref.read(loaderControllerProvider.notifier),
        super(state);

  Future<void> onGetNotification() async {
    final result = await _getNotificationUsecase.execute(null);

    result.when(
        (success) => state = state.copyWith(
              notificationList: AsyncValue.data(
                success,
              ),
            ),
        (error) => null);
  }

  Future<bool> onPostNotification(
    String message,
    String status,
    String uid,
  ) async {
    bool isSuccess = false;
    _loader.onLoad();
    final result = await _postNotificationUsecase.execute(
      NotificationRequest(
        uid: uid,
        message: message,
        status: status,
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

  Future<bool> onDeleteNotification(
    String id,
  ) async {
    bool isSuccess = false;
    _loader.onLoad();
    final result = await _deleteNotificationUsecase.execute(
      NotificationRequest(id: id),
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

  Future<bool> onUpdateNotificationUsecase(
    String id,
  ) async {
    bool isSuccess = false;
    _loader.onLoad();
    final result = await _updateNotificationUsecase.execute(
      id,
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
