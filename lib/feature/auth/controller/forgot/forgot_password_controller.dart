import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_riverpod/core/logging/logger.dart';
import 'package:practice_riverpod/core/services/network_service.dart';
import 'package:practice_riverpod/core/utils/app_urls.dart';
import 'package:practice_riverpod/feature/auth/controller/forgot/forgot_state.dart';

final forgotProvider =
    NotifierProvider.autoDispose<ForgotPasswordController, ForgotState>(
      ForgotPasswordController.new,
    );

class ForgotPasswordController extends Notifier<ForgotState> {
  @override
  ForgotState build() {
    return const ForgotState();
  }

  Future<void> forgotPassword({required String email}) async {
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      errorMessage: '',
      successMessage: '',
    );

    try {
      final response = await NetworkCaller().postRequest(
        AppUrls.forgotPassword,
        body: {"email": email},
      );

      if (response.isSuccess) {
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          successMessage: response.message,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: "Something went wrong. Please try again.",
      );
      AppLogger.error("Error in forgotPassword: $e");
    }
  }
}
