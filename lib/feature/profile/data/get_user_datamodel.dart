import 'dart:convert';

class GetUser {
  final bool success;
  final int status;
  final String message;
  final Data data;

  GetUser({
    required this.success,
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetUser.fromRawJson(String str) => GetUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GetUser.fromJson(Map<String, dynamic> json) => GetUser(
    success: json["success"],
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  final String id;
  final String fullName;
  final String email;
  final bool isVerified;
  final String createdAt;
  final String updatedAt;

  Data({
    required this.id,
    required this.fullName,
    required this.email,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    fullName: json["fullName"],
    email: json["email"],
    isVerified: json["isVerified"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "email": email,
    "isVerified": isVerified,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}
