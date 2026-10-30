import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_riverpod/core/logging/logger.dart';
import 'package:practice_riverpod/core/services/auth_service.dart';
import 'package:practice_riverpod/core/services/network_service.dart';
import 'package:practice_riverpod/core/utils/app_urls.dart';
import 'package:practice_riverpod/feature/auth/controller/verification/otp_verification_state.dart';

final otpVerificationProvider =
    NotifierProvider.autoDispose<
      OtpVerificationController,
      OtpVerificationState
    >(OtpVerificationController.new);

class OtpVerificationController extends Notifier<OtpVerificationState> {
  @override
  OtpVerificationState build() {
    return OtpVerificationState();
  }

  Future<void> verification({
    required String email,
    required String otp,
  }) async {
    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      errorMessage: "",
      successMessage: "",
    );

    try {
      final response = await NetworkCaller().postRequest(
        AppUrls.otpVerify,
        body: {"email": email, "otp": otp},
      );

      if (response.isSuccess) {
        final token = response.data?["data"]?["accessToken"];

        AppLogger.info("This is my token :- $token");
        AuthService.saveToken(token.toString());
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
        errorMessage: "Something went wrong.",
      );
      AppLogger.debug("error is $e");
    }
  }
}
