import 'package:flutter/material.dart';

class AppConstants {
  static const Color primaryColor = Color(0xFF0020BD);
  static const Color secondaryColor = Color(0xFFF5F7FA);
  static const Color accentColor = Color(0xFF4285F4);
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color successColor = Color(0xFF38A169);
  static const Color warningColor = Color(0xFFED8936);
  
  static const String appName = 'D2O Meeting Rooms';
  static const String tagline = 'Made With BrainBox';
  
  static const List<String> floors = ['All Floors', '2nd Floor', '3rd Floor', '4th Floor', '5th Floor'];
  static const List<String> roomTypes = ['All Types', 'Conference', 'Meeting', 'Huddle', 'Presentation'];
  
  static const List<String> timeSlots = [
    '09:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '12:00 - 13:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
    '16:00 - 17:00',
    '17:00 - 18:00',
  ];
}