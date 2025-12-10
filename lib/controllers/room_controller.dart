import 'package:flutter/material.dart';
import '../models/room.dart';
import '../services/static_data_service.dart';

class RoomController extends ChangeNotifier {
  List<Room> _rooms = [];
  List<Room> _filteredRooms = [];
  String _searchQuery = '';
  String _selectedFloor = 'All Floors';
  String _selectedRoomType = 'All Types';
  bool _isLoading = false;
  
  List<Room> get rooms => _filteredRooms;
  String get searchQuery => _searchQuery;
  String get selectedFloor => _selectedFloor;
  String get selectedRoomType => _selectedRoomType;
  bool get isLoading => _isLoading;
  
  RoomController() {
    loadRooms();
  }
  
  Future<void> loadRooms() async {
    _isLoading = true;
    notifyListeners();
    
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate loading
    _rooms = StaticDataService.getRooms();
    _filteredRooms = List.from(_rooms);
    
    _isLoading = false;
    notifyListeners();
  }
  
  void searchRooms(String query) {
    _searchQuery = query;
    _applyFilters();
  }
  
  void setFloorFilter(String floor) {
    _selectedFloor = floor;
    _applyFilters();
  }
  
  void setRoomTypeFilter(String roomType) {
    _selectedRoomType = roomType;
    _applyFilters();
  }
  
  void _applyFilters() {
    _filteredRooms = _rooms.where((room) {
      bool matchesSearch = _searchQuery.isEmpty ||
          room.name.toLowerCase().contains(_searchQuery.toLowerCase());
      
      bool matchesFloor = _selectedFloor == 'All Floors' ||
          room.floor == _selectedFloor;
      
      bool matchesType = _selectedRoomType == 'All Types' ||
          room.type == _selectedRoomType;
      
      return matchesSearch && matchesFloor && matchesType;
    }).toList();
    
    notifyListeners();
  }
  
  Room? getRoomById(String id) {
    try {
      return _rooms.firstWhere((room) => room.id == id);
    } catch (e) {
      return null;
    }
  }
  
  void clearFilters() {
    _searchQuery = '';
    _selectedFloor = 'All Floors';
    _selectedRoomType = 'All Types';
    _filteredRooms = List.from(_rooms);
    notifyListeners();
  }
}