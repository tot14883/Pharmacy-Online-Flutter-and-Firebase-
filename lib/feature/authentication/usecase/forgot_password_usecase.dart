import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/application/usecase.dart';
import 'package:pharmacy_online/core/firebase/auth/auth_provider.dart';
import 'package:pharmacy_online/feature/authentication/model/request/forgot_password_request.dart';

final forgotPasswordUsecaseProvider = Provider<ForgotPasswordUsecase>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return ForgotPasswordUsecase(
    ref,
    firebaseAuth,
  );
});

class ForgotPasswordUsecase extends UseCase<ForgotPasswordRequest, bool> {
  final FirebaseAuthProvider firebaseAuth;

  ForgotPasswordUsecase(
    Ref ref,
    this.firebaseAuth,
  ) {
    this.ref = ref;
  }

  @override
  Future<bool> exec(
    ForgotPasswordRequest request,
  ) async {
    try {
      final result = await firebaseAuth.sendPasswordResetEmail(request.email);

      return result;
    } catch (e) {
      return false;
    }
  }
}
