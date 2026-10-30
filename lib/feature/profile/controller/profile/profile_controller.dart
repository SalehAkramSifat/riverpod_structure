import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice_riverpod/core/logging/logger.dart';
import 'package:practice_riverpod/core/services/auth_service.dart';
import 'package:practice_riverpod/core/services/network_service.dart';
import 'package:practice_riverpod/core/utils/app_urls.dart';
import 'package:practice_riverpod/feature/profile/controller/profile/profile_state.dart';
import 'package:practice_riverpod/feature/profile/data/get_user_datamodel.dart';

final profileProvider =
    NotifierProvider.autoDispose<ProfileController, ProfileState>(
      ProfileController.new,
    );

class ProfileController extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return const ProfileState();
  }

  Future<void> getMe() async {
    AppLogger.info('🔑 [ProfileController.getMe] AuthService.token: ${AuthService.token}');

    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      errorMessage: '',
      successMessage: '',
    );

    try {
      final response = await NetworkCaller().getRequest(
        AppUrls.getMe,
        token: AuthService.token,
      );
      if (response.isSuccess && response.responseData != null) {
        final Map<String, dynamic> rawData = response.responseData is String
            ? jsonDecode(response.responseData)
            : response.responseData as Map<String, dynamic>;

        final getUserModel = GetUser.fromJson(rawData);

        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
          userData: getUserModel.data,
          successMessage: getUserModel.message,
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
        errorMessage: "Something went wrong",
      );
      AppLogger.error("Profile get error: $e");
    }
  }
}
