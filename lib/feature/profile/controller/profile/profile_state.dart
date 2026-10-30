import 'package:practice_riverpod/feature/profile/data/get_user_datamodel.dart';

class ProfileState {
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;
  final String successMessage;
  final Data? userData;

  const ProfileState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage = '',
    this.successMessage = '',
    this.userData,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? successMessage,
    Data? userData,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      userData: userData ?? this.userData,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          isSuccess == other.isSuccess &&
          errorMessage == other.errorMessage &&
          successMessage == other.successMessage &&
          userData == other.userData;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      isSuccess.hashCode ^
      errorMessage.hashCode ^
      successMessage.hashCode ^
      userData.hashCode;
}
