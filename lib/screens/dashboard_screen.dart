import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/room_controller.dart';
import '../controllers/booking_controller.dart';
import '../controllers/notification_controller.dart';
import '../widgets/room_card.dart';
import '../widgets/booking_card.dart';
import '../utils/constants.dart';
import 'my_bookings_screen.dart';
import 'notifications_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('D2O Meeting Rooms'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Consumer<NotificationController>(
            builder: (context, notificationController, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  if (notificationController.unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${notificationController.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search rooms...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    context.read<RoomController>().searchRooms(value);
                  },
                ),
                const SizedBox(height: 16),
                // Filters
                Row(
                  children: [
                    Expanded(
                      child: Consumer<RoomController>(
                        builder: (context, roomController, child) {
                          return DropdownButtonFormField<String>(
                            value: roomController.selectedFloor,
                            decoration: const InputDecoration(
                              labelText: 'Floor',
                              border: OutlineInputBorder(),
                            ),
                            items: AppConstants.floors.map((floor) {
                              return DropdownMenuItem(
                                value: floor,
                                child: Text(floor),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                roomController.setFloorFilter(value);
                              }
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Consumer<RoomController>(
                        builder: (context, roomController, child) {
                          return DropdownButtonFormField<String>(
                            value: roomController.selectedRoomType,
                            decoration: const InputDecoration(
                              labelText: 'Type',
                              border: OutlineInputBorder(),
                            ),
                            items: AppConstants.roomTypes.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                roomController.setRoomTypeFilter(value);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tabs
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppConstants.primaryColor,
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: AppConstants.primaryColor,
              tabs: const [
                Tab(text: 'Available Rooms'),
                Tab(text: 'My Bookings'),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAvailableRoomsTab(),
                _buildMyBookingsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyBookingsScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Book Room'),
        backgroundColor: AppConstants.primaryColor,
      ),
    );
  }

  Widget _buildAvailableRoomsTab() {
    return Consumer<RoomController>(
      builder: (context, roomController, child) {
        if (roomController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (roomController.rooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No rooms found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: roomController.rooms.length,
          itemBuilder: (context, index) {
            final room = roomController.rooms[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: RoomCard(room: room),
            );
          },
        );
      },
    );
  }

  Widget _buildMyBookingsTab() {
    return Consumer<BookingController>(
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
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No bookings yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Book a room to get started',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookingController.bookings.length,
          itemBuilder: (context, index) {
            final booking = bookingController.bookings[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BookingCard(booking: booking),
            );
          },
        );
      },
    );
  }
}