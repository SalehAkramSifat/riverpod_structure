import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_structure/features/notifications/presentation/provider/state/notification_state.dart';
import 'package:riverpod_structure/features/notifications/presentation/provider/state/notifications_notifier.dart';

final notificationStateProvider =
    NotifierProvider<NotificationNotifier, NotificationState>(
  NotificationNotifier.new,
);
