class RegisterState {
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;
  final String successMessage;

  const RegisterState({
    this.isLoading = false,
    this.errorMessage = "",
    this.isSuccess = false,
    this.successMessage = "",
  });

  RegisterState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    String? successMessage,
  }) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          errorMessage == other.errorMessage &&
          isSuccess == other.isSuccess &&
          successMessage == other.successMessage;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      errorMessage.hashCode ^
      isSuccess.hashCode ^
      successMessage.hashCode;
}
