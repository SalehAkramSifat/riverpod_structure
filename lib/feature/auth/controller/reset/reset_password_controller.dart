import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_riverpod/core/services/auth_service.dart';
import 'package:practice_riverpod/core/services/network_service.dart';
import 'package:practice_riverpod/core/utils/app_urls.dart';
import 'package:practice_riverpod/feature/auth/controller/reset/reset_state.dart';

final resetProvider =
    NotifierProvider.autoDispose<ResetPasswordController, ResetState>(
      ResetPasswordController.new,
    );

class ResetPasswordController extends Notifier<ResetState> {
  @override
  ResetState build() {
    return ResetState();
  }

  Future<void> resetPassword({required String password}) async {
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      errorMessage: "",
      successMessage: "",
    );

    try {
      final response = await NetworkCaller().postRequest(
        AppUrls.resetPassowrd,
        token: AuthService.token,
        body: {"password": password},
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
        errorMessage: "Something went wrong $e",
      );
    }
  }
}
