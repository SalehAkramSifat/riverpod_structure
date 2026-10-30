import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_riverpod/core/logging/logger.dart';
import 'package:practice_riverpod/core/services/auth_service.dart';
import 'package:practice_riverpod/core/services/network_service.dart';
import 'package:practice_riverpod/core/utils/app_urls.dart';
import 'package:practice_riverpod/feature/auth/controller/register/register_state.dart';

final registerProvider =
    NotifierProvider.autoDispose<RegisterController, RegisterState>(
      RegisterController.new,
    );

class RegisterController extends Notifier<RegisterState> {
  @override
  RegisterState build() {
    return RegisterState();
  }

  Future<void> createAccount({
    required String email,
    required String name,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      errorMessage: '',
      successMessage: '',
    );

    try {
      final response = await NetworkCaller().postRequest(
        AppUrls.register,
        body: {"email": email, "fullName": name, "password": password},
      );

      if (response.isSuccess) {
        final token = response.responseData?["data"]?["accessToken"];
        AppLogger.info("This is token :====== $token");
        if (token != null) {
          await AuthService.saveToken(token);
        }
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
      AppLogger.error("This is error message: $e");
      state = state.copyWith(
        isLoading: false,
        errorMessage: "Something went wrong",
        isSuccess: false,
      );
    }
  }
}
