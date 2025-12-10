import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../controllers/notification_controller.dart';
import '../widgets/notification_item.dart';
import '../utils/constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        actions: [
          Consumer<NotificationController>(
            builder: (context, notificationController, child) {
              if (notificationController.unreadCount > 0) {
                return TextButton(
                  onPressed: () {
                    notificationController.markAllAsRead();
                  },
                  child: const Text(
                    'Mark All Read',
                    style: TextStyle(color: AppConstants.primaryColor),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<NotificationController>(
        builder: (context, notificationController, child) {
          if (notificationController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notificationController.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your booking notifications will appear here',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Group notifications by date
          final groupedNotifications = <String, List<dynamic>>{};
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final yesterday = today.subtract(const Duration(days: 1));

          for (final notification in notificationController.notifications) {
            final notificationDate = DateTime(
              notification.timestamp.year,
              notification.timestamp.month,
              notification.timestamp.day,
            );

            String dateKey;
            if (notificationDate.isAtSameMomentAs(today)) {
              dateKey = 'Today';
            } else if (notificationDate.isAtSameMomentAs(yesterday)) {
              dateKey = 'Yesterday';
            } else {
              dateKey = DateFormat('MMM dd, yyyy').format(notificationDate);
            }

            if (!groupedNotifications.containsKey(dateKey)) {
              groupedNotifications[dateKey] = [];
            }
            groupedNotifications[dateKey]!.add(notification);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groupedNotifications.length,
            itemBuilder: (context, index) {
              final dateKey = groupedNotifications.keys.elementAt(index);
              final notifications = groupedNotifications[dateKey]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (index > 0) const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Text(
                      dateKey,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                  ...notifications.map((notification) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: NotificationItem(
                          notification: notification,
                          onTap: () {
                            if (!notification.isRead) {
                              notificationController.markAsRead(notification.id);
                            }
                            // Handle navigation to related booking if needed
                          },
                        ),
                      )),
                ],
              );
            },
          );
        },
      ),
    );
  }
}