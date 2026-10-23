import 'package:equatable/equatable.dart';
import 'package:riverpod_structure/features/notifications/data/models/notification.dart';

class NotificationState extends Equatable {
  final List<NotificationModel> notifications;
  final bool isLoading;
  final String message;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = false,
    this.message = '',
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    bool? isLoading,
    String? message,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [notifications, isLoading, message];
}
