import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_riverpod/core/logging/logger.dart';
import 'package:practice_riverpod/core/services/auth_service.dart';
import 'package:practice_riverpod/core/services/network_service.dart';
import 'package:practice_riverpod/core/utils/app_urls.dart';
import 'package:practice_riverpod/feature/auth/controller/login/login_state.dart';
export 'login_state.dart';

final loginProvider = NotifierProvider.autoDispose<LoginController, LoginState>(
  LoginController.new,
);

class LoginController extends Notifier<LoginState> {
  @override
  LoginState build() {
    return const LoginState();
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, isSuccess: false);

    try {
      final response = await NetworkCaller().postRequest(
        AppUrls.login,
        body: {"email": email, "password": password},
      );
      if (response.isSuccess) {
        final data = response.responseData;

        final token = data?["data"]?["accessToken"] ??
            data?["accessToken"] ??
            data?["data"]?["token"] ??
            data?["token"];

        AppLogger.debug("This is my access token $token");
        if (token != null) {
          await AuthService.saveToken(token.toString());
        }
        state = state.copyWith(
          isLoading: false,
          isNotVerifed: false,
          isSuccess: true,
          isSuccessMessage: response.message,
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
