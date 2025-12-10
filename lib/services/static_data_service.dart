import '../models/room.dart';
import '../models/booking.dart';
import '../models/notification.dart';

class StaticDataService {
  static List<Room> getRooms() {
    return [
      Room(
        id: '1',
        name: 'Innovation Hub',
        floor: '2nd Floor',
        type: 'Conference',
        capacity: 12,
        imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=800',
        amenities: ['Projector', 'Whiteboard', 'Video Conferencing', 'WiFi'],
      ),
      Room(
        id: '2',
        name: 'Brainstorm Room',
        floor: '2nd Floor',
        type: 'Meeting',
        capacity: 8,
        imageUrl: 'https://images.unsplash.com/photo-1431540015161-0bf868a2d407?w=800',
        amenities: ['Whiteboard', 'WiFi', 'Coffee Machine'],
      ),
      Room(
        id: '3',
        name: 'Executive Suite',
        floor: '3rd Floor',
        type: 'Conference',
        capacity: 16,
        imageUrl: 'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=800',
        amenities: ['Projector', 'Video Conferencing', 'WiFi', 'Audio System'],
      ),
      Room(
        id: '4',
        name: 'Quick Connect',
        floor: '3rd Floor',
        type: 'Huddle',
        capacity: 4,
        imageUrl: 'https://images.unsplash.com/photo-1582653291997-079a1c04e5a1?w=800',
        amenities: ['TV Screen', 'WiFi'],
      ),
      Room(
        id: '5',
        name: 'Presentation Theater',
        floor: '4th Floor',
        type: 'Presentation',
        capacity: 20,
        imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800',
        amenities: ['Large Screen', 'Audio System', 'Microphone', 'WiFi'],
      ),
      Room(
        id: '6',
        name: 'Focus Pod',
        floor: '4th Floor',
        type: 'Huddle',
        capacity: 6,
        imageUrl: 'https://images.unsplash.com/photo-1556761175-5973dc0f32e7?w=800',
        amenities: ['TV Screen', 'WiFi', 'Soundproof'],
      ),
      Room(
        id: '7',
        name: 'Collaboration Zone',
        floor: '5th Floor',
        type: 'Meeting',
        capacity: 10,
        imageUrl: 'https://images.unsplash.com/photo-1552664730-d307ca884978?w=800',
        amenities: ['Projector', 'Whiteboard', 'WiFi'],
      ),
      Room(
        id: '8',
        name: 'Executive Boardroom',
        floor: '5th Floor',
        type: 'Conference',
        capacity: 14,
        imageUrl: 'https://images.unsplash.com/photo-1563298723-dcfebaa392e3?w=800',
        amenities: ['Large Table', 'Video Conferencing', 'Projector', 'WiFi'],
      ),
    ];
  }
  
  static List<Booking> getBookings() {
    final now = DateTime.now();
    return [
      Booking(
        id: '1',
        roomId: '1',
        roomName: 'Innovation Hub',
        floor: '2nd Floor',
        date: now.add(const Duration(days: 1)),
        timeSlot: '10:00 - 11:00',
        userId: 'user1',
        userName: 'John Doe',
        status: BookingStatus.confirmed,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      Booking(
        id: '2',
        roomId: '3',
        roomName: 'Executive Suite',
        floor: '3rd Floor',
        date: now.add(const Duration(days: 3)),
        timeSlot: '14:00 - 15:00',
        userId: 'user1',
        userName: 'John Doe',
        status: BookingStatus.confirmed,
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
      Booking(
        id: '3',
        roomId: '5',
        roomName: 'Presentation Theater',
        floor: '4th Floor',
        date: now.add(const Duration(days: 7)),
        timeSlot: '09:00 - 10:00',
        userId: 'user1',
        userName: 'John Doe',
        status: BookingStatus.pending,
        createdAt: now.subtract(const Duration(minutes: 30)),
      ),
    ];
  }
  
  static List<AppNotification> getNotifications() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: '1',
        title: 'Booking Confirmed',
        description: 'Your booking for Innovation Hub is confirmed for tomorrow at 10:00 AM',
        timestamp: now.subtract(const Duration(minutes: 30)),
        type: NotificationType.booking,
        bookingId: '1',
      ),
      AppNotification(
        id: '2',
        title: 'Booking Reminder',
        description: 'You have a meeting in Executive Suite in 1 hour',
        timestamp: now.subtract(const Duration(hours: 1)),
        type: NotificationType.reminder,
        bookingId: '2',
      ),
      AppNotification(
        id: '3',
        title: 'Booking Updated',
        description: 'Your booking for Presentation Theater has been updated',
        timestamp: now.subtract(const Duration(hours: 2)),
        type: NotificationType.update,
        bookingId: '3',
      ),
    ];
  }
}