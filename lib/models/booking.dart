class Booking {
  final String id;
  final String roomId;
  final String roomName;
  final String floor;
  final DateTime date;
  final String timeSlot;
  final String userId;
  final String userName;
  final BookingStatus status;
  final DateTime createdAt;
  
  Booking({
    required this.id,
    required this.roomId,
    required this.roomName,
    required this.floor,
    required this.date,
    required this.timeSlot,
    required this.userId,
    required this.userName,
    required this.status,
    required this.createdAt,
  });
  
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      roomId: json['roomId'],
      roomName: json['roomName'],
      floor: json['floor'],
      date: DateTime.parse(json['date']),
      timeSlot: json['timeSlot'],
      userId: json['userId'],
      userName: json['userName'],
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomId': roomId,
      'roomName': roomName,
      'floor': floor,
      'date': date.toIso8601String(),
      'timeSlot': timeSlot,
      'userId': userId,
      'userName': userName,
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

enum BookingStatus { confirmed, pending, cancelled }