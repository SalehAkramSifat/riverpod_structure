import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/features/notifications/data/repository/notifications_repository_impl.dart';
import 'package:riverpod_structure/features/notifications/domain/repository/notifications_repository.dart';
import 'package:riverpod_structure/features/notifications/domain/use_cases/clear_all_notifications_use_case.dart';
import 'package:riverpod_structure/features/notifications/domain/use_cases/get_all_notifications_use_case.dart';

// Repository
final notificationRepositoryProvider =
    Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl();
});

// Use Cases
final getAllNotificationsUseCaseProvider =
    Provider<GetAllNotificationsUseCase>((ref) {
  return GetAllNotificationsUseCase(
    notificationRepository: ref.watch(notificationRepositoryProvider),
  );
});

final clearAllNotificationsUseCaseProvider =
    Provider<ClearAllNotificationsUseCase>((ref) {
  return ClearAllNotificationsUseCase(
    notificationRepository: ref.watch(notificationRepositoryProvider),
  );
});
