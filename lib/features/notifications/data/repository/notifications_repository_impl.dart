import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';
import 'package:riverpod_structure/features/notifications/data/models/notification.dart';
import 'package:riverpod_structure/features/notifications/domain/repository/notifications_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  NotificationRepositoryImpl();

  @override
  Future<Either<AppException, List<NotificationModel>>>
  getNotifications() async {
    return const Right([]);
  }

  @override
  Future<void> clearNotifications() async {}
}
