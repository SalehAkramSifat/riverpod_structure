import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/core/constants/app_urls.dart';
import 'package:riverpod_structure/core/network/interceptors/auth_interceptor.dart';
import 'package:riverpod_structure/core/network/interceptors/logging_interceptor.dart';
import 'package:riverpod_structure/core/storage/secure_storage_service.dart';

final dioProvider = Provider<Dio>((ref) {
  final storage = ref.watch(secureStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: AppUrls.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
      responseType: ResponseType.json,
      validateStatus: (status) => status != null && status >= 200 && status < 300,
    ),
  );

  dio.interceptors.addAll([
    AuthInterceptor(storage: storage),
    LoggingInterceptor(),
  ]);

  return dio;
});
