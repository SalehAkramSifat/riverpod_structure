// To parse this JSON data, do
//
//     final otpVerificationState = otpVerificationStateFromJson(jsonString);

import 'dart:convert';

OtpVerificationState otpVerificationStateFromJson(String str) =>
    OtpVerificationState.fromJson(json.decode(str));

String otpVerificationStateToJson(OtpVerificationState data) =>
    json.encode(data.toJson());

class OtpVerificationState {
  final bool? isLoading;
  final bool? isSuccess;
  final String? errorMessage;
  final String? successMessage;

  OtpVerificationState({
    this.isLoading,
    this.isSuccess,
    this.errorMessage,
    this.successMessage,
  });

  OtpVerificationState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    String? successMessage,
  }) => OtpVerificationState(
    isLoading: isLoading ?? this.isLoading,
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage,
    successMessage: successMessage ?? this.successMessage,
  );

  factory OtpVerificationState.fromJson(Map<String, dynamic> json) =>
      OtpVerificationState(
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
