class Room {
  final String id;
  final String name;
  final String floor;
  final String type;
  final int capacity;
  final String imageUrl;
  final List<String> amenities;
  final bool isAvailable;
  
  Room({
    required this.id,
    required this.name,
    required this.floor,
    required this.type,
    required this.capacity,
    required this.imageUrl,
    required this.amenities,
    this.isAvailable = true,
  });
  
  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      name: json['name'],
      floor: json['floor'],
      type: json['type'],
      capacity: json['capacity'],
      imageUrl: json['imageUrl'],
      amenities: List<String>.from(json['amenities']),
      isAvailable: json['isAvailable'] ?? true,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'floor': floor,
      'type': type,
      'capacity': capacity,
      'imageUrl': imageUrl,
      'amenities': amenities,
      'isAvailable': isAvailable,
    };
  }
}