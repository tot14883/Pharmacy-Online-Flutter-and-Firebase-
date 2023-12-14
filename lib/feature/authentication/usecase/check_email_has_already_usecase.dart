import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';

final checkEmailHasAlreadyUsecaseProvider =
    Provider<CheckEmailHasAlreadyUsecase>((ref) {
  final fireCloudStore = ref.watch(firebaseCloudStoreProvider);
  return CheckEmailHasAlreadyUsecase(
    ref,
    fireCloudStore,
  );
});

class CheckEmailHasAlreadyUsecase extends UseCase<String, bool> {
  final FirebaseCloudStore fireCloudStore;

  CheckEmailHasAlreadyUsecase(
    Ref ref,
    this.fireCloudStore,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    String request,
  ) async {
    try {
      final collect = await fireCloudStore
          .collection('user')
          .where(
            'email',
            isEqualTo: request,
          )
          .get()
          .then((value) => value.docs);

      return collect.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
