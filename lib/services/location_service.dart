import 'package:geolocator/geolocator.dart';
import '../models/geo.dart';

enum LocationStatus { ok, denied, deniedForever, serviceDisabled }

class LocationResult {
  final LocationStatus status;
  final GeoPoint? point;
  const LocationResult(this.status, [this.point]);
}

/// Wraps geolocator with explicit permission state. Never throws on denial.
class LocationService {
  Future<LocationResult> currentPosition({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration timeout = const Duration(seconds: 8),
  }) async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return const LocationResult(LocationStatus.serviceDisabled);

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever) {
      return const LocationResult(LocationStatus.deniedForever);
    }
    if (perm == LocationPermission.denied) {
      return const LocationResult(LocationStatus.denied);
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: accuracy,
        timeLimit: timeout,
      );
      return LocationResult(
        LocationStatus.ok,
        GeoPoint(latitude: pos.latitude, longitude: pos.longitude),
      );
    } catch (_) {
      return const LocationResult(LocationStatus.serviceDisabled);
    }
  }
}
