import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/booking_controller.dart';
import '../controllers/notification_controller.dart';
import '../widgets/booking_card.dart';
import '../models/notification.dart';
import '../utils/constants.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.white,
      ),
      body: Consumer<BookingController>(
        builder: (context, bookingController, child) {
          if (bookingController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (bookingController.bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.event_busy,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No bookings yet',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Book a room to see your reservations here',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Book a Room'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Group bookings by status
          final upcomingBookings = bookingController.bookings
              .where((booking) =>
                  booking.date.isAfter(DateTime.now().subtract(const Duration(days: 1))))
              .toList();
          
          final pastBookings = bookingController.bookings
              .where((booking) =>
                  booking.date.isBefore(DateTime.now().subtract(const Duration(days: 1))))
              .toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (upcomingBookings.isNotEmpty) ...<Widget>[
                  Text(
                    'Upcoming Bookings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...upcomingBookings.map((booking) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: BookingCard(
                          booking: booking,
                          onEdit: () => _handleEdit(context, booking.id),
                          onCancel: () => _handleCancel(context, booking.id),
                        ),
                      )),
                  const SizedBox(height: 24),
                ],
                
                if (pastBookings.isNotEmpty) ...<Widget>[
                  Text(
                    'Past Bookings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...pastBookings.map((booking) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: BookingCard(
                          booking: booking,
                          isPast: true,
                        ),
                      )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleEdit(BuildContext context, String bookingId) {
    final booking = context.read<BookingController>().getBookingById(bookingId);
    if (booking != null) {
      // Navigate to room detail screen with existing booking
      // This would require importing the room controller to get room details
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Edit functionality would open room detail screen'),
        ),
      );
    }
  }

  void _handleCancel(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: const Text(
            'Are you sure you want to cancel this booking? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Keep Booking'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                
                final booking = context.read<BookingController>().getBookingById(bookingId);
                if (booking != null) {
                  await context.read<BookingController>().cancelBooking(bookingId);
                  
                  // Add cancellation notification
                  final notification = AppNotification(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: 'Booking Cancelled',
                    description:
                        'Your booking for ${booking.roomName} has been cancelled successfully.',
                    timestamp: DateTime.now(),
                    type: NotificationType.cancellation,
                  );
                  
                  context.read<NotificationController>().addNotification(notification);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Booking cancelled successfully'),
                      backgroundColor: AppConstants.successColor,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancel Booking'),
            ),
          ],
        );
      },
    );
  }
}