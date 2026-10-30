// To parse this JSON data, do
//
//     final forgotState = forgotStateFromJson(jsonString);

import 'dart:convert';

ForgotState forgotStateFromJson(String str) =>
    ForgotState.fromJson(json.decode(str));

String forgotStateToJson(ForgotState data) => json.encode(data.toJson());

class ForgotState {
  final bool? isLoading;
  final bool? isSuccess;
  final String? errorMessage;
  final String? successMessage;

  ForgotState({
    this.isLoading,
    this.isSuccess,
    this.errorMessage,
    this.successMessage,
  });

  ForgotState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? successMessage,
  }) => ForgotState(
    isLoading: isLoading ?? this.isLoading,
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage,
    successMessage: successMessage ?? this.successMessage,
  );

  factory ForgotState.fromJson(Map<String, dynamic> json) => ForgotState(
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
