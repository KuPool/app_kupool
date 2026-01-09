import 'package:Kupool/net/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Change the return type to Map<String, dynamic>? to hold the full announcement object.
final announcementProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final apiService = ApiService();
  final response = await apiService.get('/v1/announcements/recent');

  if (response is List && response.isNotEmpty) {
    // Return the whole first announcement object, which is a Map.
    final firstAnnouncement = response.first as Map<String, dynamic>?;
    return firstAnnouncement;
  }
  
  return null; // Return null if parsing fails or the list is empty.
});
