import '../../model/ride/ride_pref.dart';
import '../ride_preferences_repository.dart';

class MockRidePreferencesRepository implements RidePreferencesRepository {
  final List<RidePreference> _pastPreferences = [];

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate delay
    return _pastPreferences;
  }

  @override
  Future<void> addPreference(RidePreference preference) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate delay
    _pastPreferences.add(preference);
  }
}