import 'package:google_maps_flutter/google_maps_flutter.dart';

class WalkData {
  final double distance;
  final Duration duration;
  final DateTime timestamp;
  final List<LatLng> path;

  WalkData({
    required this.distance,
    required this.duration,
    required this.timestamp,
    required this.path,
  });
}

class WalkDataService {
//TODO: CREATE THE SERVICE FOR STORING IT INTO THE SPECIFIC PET
}
