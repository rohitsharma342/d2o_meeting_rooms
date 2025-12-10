import 'package:flutter/material.dart';
import '../models/notification.dart';
import '../services/static_data_service.dart';

class NotificationController extends ChangeNotifier {
  List<AppNotification> _notifications = [];
  bool _isLoading = false;
  
  List<AppNotification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  
  NotificationController() {
    loadNotifications();
  }
  
  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _notifications = StaticDataService.getNotifications();
    
    _isLoading = false;
    notifyListeners();
  }
  
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }
  
  void markAllAsRead() {
    _notifications = _notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    notifyListeners();
  }
  
  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }
  
  void removeNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }
}