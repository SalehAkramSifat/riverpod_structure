import 'package:riverpod_structure/features/notifications/domain/repository/notifications_repository.dart';

class ClearAllNotificationsUseCase {
  final NotificationRepository notificationRepository;

  ClearAllNotificationsUseCase({required this.notificationRepository});

  Future<void> execute() {
    return notificationRepository.clearNotifications();
  }
}
