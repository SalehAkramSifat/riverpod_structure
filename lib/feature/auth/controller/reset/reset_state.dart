import 'dart:convert';

class ResetState {
  final bool isLoading;
  final bool isSuccess;
  final String errorMessage;
  final String successMessage;

  ResetState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage = '',
    this.successMessage = '',
  });
  ResetState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? successMessage,
  }) => ResetState(
    isLoading: isLoading ?? this.isLoading,
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage,
    successMessage: successMessage ?? this.successMessage,
  );

  factory ResetState.fromRawJson(String str) =>
      ResetState.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResetState.fromJson(Map<String, dynamic> json) => ResetState(
    isLoading: json["isLoading"],
    isSuccess: json["isSuccess"],
    errorMessage: json["errorMessage"],
    successMessage: json["successMessage"],
  );

  Map<String, dynamic> toJson() => {
    "isLoading": isLoading,
    "isSuccess": isSuccess,
    "errorMessage": errorMessage,
    "successMessage": successMessage,
  };
}
