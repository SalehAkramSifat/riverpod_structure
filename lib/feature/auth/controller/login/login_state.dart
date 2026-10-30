class LoginState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final bool isNotVerifed;
  final String? isSuccessMessage;

  const LoginState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.isNotVerifed = false,
    this.isSuccessMessage,
  });

  LoginState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    bool? isNotVerifed,
    String? isSuccessMessage,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      isNotVerifed: isNotVerifed ?? this.isNotVerifed,
      isSuccessMessage: isSuccessMessage ?? this.isSuccessMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          errorMessage == other.errorMessage &&
          isSuccess == other.isSuccess &&
          isNotVerifed == other.isNotVerifed &&
          isSuccessMessage == other.isSuccessMessage;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      errorMessage.hashCode ^
      isSuccess.hashCode ^
      isNotVerifed.hashCode ^
      isSuccessMessage.hashCode;
}
