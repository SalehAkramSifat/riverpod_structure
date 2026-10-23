import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/features/notifications/domain/use_cases/clear_all_notifications_use_case.dart';
import 'package:riverpod_structure/features/notifications/domain/use_cases/get_all_notifications_use_case.dart';
import 'package:riverpod_structure/features/notifications/presentation/provider/notification_providers.dart';
import 'package:riverpod_structure/features/notifications/presentation/provider/state/notification_state.dart';

final notificationsNotifierProvider =
    NotifierProvider<NotificationNotifier, NotificationState>(
  NotificationNotifier.new,
);

class NotificationNotifier extends Notifier<NotificationState> {
  GetAllNotificationsUseCase get _getAllNotificationsUseCase =>
      ref.read(getAllNotificationsUseCaseProvider);
  ClearAllNotificationsUseCase get _clearAllNotificationsUseCase =>
      ref.read(clearAllNotificationsUseCaseProvider);

  @override
  NotificationState build() {
    return const NotificationState();
  }

  Future<void> getAllNotifications() async {
    state = state.copyWith(isLoading: true);
    final response = await _getAllNotificationsUseCase.execute();
    response.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        message: failure.message,
      ),
      (data) => state = state.copyWith(
        isLoading: false,
        notifications: data,
      ),
    );
  }

  Future<void> clearNotifications() async {
    await _clearAllNotificationsUseCase.execute();
    state = state.copyWith(notifications: const []);
  }
}
