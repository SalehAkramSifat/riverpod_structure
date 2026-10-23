import 'package:dartz/dartz.dart';
import 'package:riverpod_structure/features/notifications/data/models/notification.dart';
import 'package:riverpod_structure/core/exceptions/app_exception.dart';

abstract class NotificationRepository {
  Future<Either<AppException, List<NotificationModel>>> getNotifications();

  Future<void> clearNotifications();
}
