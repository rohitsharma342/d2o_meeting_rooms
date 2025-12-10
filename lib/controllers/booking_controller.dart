import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/static_data_service.dart';
import '../utils/constants.dart';

class BookingController extends ChangeNotifier {
  List<Booking> _bookings = [];
  bool _isLoading = false;
  
  List<Booking> get bookings => _bookings;
  bool get isLoading => _isLoading;
  
  BookingController() {
    loadBookings();
  }
  
  Future<void> loadBookings() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _bookings = StaticDataService.getBookings();
    
    _isLoading = false;
    notifyListeners();
  }
  
  Future<bool> createBooking({
    required String roomId,
    required String roomName,
    required String floor,
    required DateTime date,
    required String timeSlot,
  }) async {
    _isLoading = true;
    notifyListeners();
    
    // Check for conflicts
    bool hasConflict = _bookings.any((booking) =>
        booking.roomId == roomId &&
        booking.date.year == date.year &&
        booking.date.month == date.month &&
        booking.date.day == date.day &&
        booking.timeSlot == timeSlot &&
        booking.status != BookingStatus.cancelled);
    
    if (hasConflict) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    
    final newBooking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      roomId: roomId,
      roomName: roomName,
      floor: floor,
      date: date,
      timeSlot: timeSlot,
      userId: 'user1',
      userName: 'John Doe',
      status: BookingStatus.confirmed,
      createdAt: DateTime.now(),
    );
    
    _bookings.add(newBooking);
    _isLoading = false;
    notifyListeners();
    return true;
  }
  
  Future<bool> updateBooking({
    required String bookingId,
    required DateTime newDate,
    required String newTimeSlot,
  }) async {
    _isLoading = true;
    notifyListeners();
    
    final bookingIndex = _bookings.indexWhere((b) => b.id == bookingId);
    if (bookingIndex == -1) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    
    final booking = _bookings[bookingIndex];
    
    // Check for conflicts (excluding current booking)
    bool hasConflict = _bookings.any((b) =>
        b.roomId == booking.roomId &&
        b.id != bookingId &&
        b.date.year == newDate.year &&
        b.date.month == newDate.month &&
        b.date.day == newDate.day &&
        b.timeSlot == newTimeSlot &&
        b.status != BookingStatus.cancelled);
    
    if (hasConflict) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    _bookings[bookingIndex] = Booking(
      id: booking.id,
      roomId: booking.roomId,
      roomName: booking.roomName,
      floor: booking.floor,
      date: newDate,
      timeSlot: newTimeSlot,
      userId: booking.userId,
      userName: booking.userName,
      status: booking.status,
      createdAt: booking.createdAt,
    );
    
    _isLoading = false;
    notifyListeners();
    return true;
  }
  
  Future<void> cancelBooking(String bookingId) async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    final bookingIndex = _bookings.indexWhere((b) => b.id == bookingId);
    if (bookingIndex != -1) {
      _bookings.removeAt(bookingIndex);
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  List<String> getAvailableTimeSlots(String roomId, DateTime date) {
    final bookedSlots = _bookings
        .where((booking) =>
            booking.roomId == roomId &&
            booking.date.year == date.year &&
            booking.date.month == date.month &&
            booking.date.day == date.day &&
            booking.status != BookingStatus.cancelled)
        .map((booking) => booking.timeSlot)
        .toList();
    
    return AppConstants.timeSlots
        .where((slot) => !bookedSlots.contains(slot))
        .toList();
  }
  
  Booking? getBookingById(String id) {
    try {
      return _bookings.firstWhere((booking) => booking.id == id);
    } catch (e) {
      return null;
    }
  }
}