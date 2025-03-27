import 'package:flutter/foundation.dart';
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/data/repository/ride_preferences_repository.dart';
import 'package:week_3_blabla_project/ui/providers/async_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  final RidePreferencesRepository ridePreferencesRepository;

  RidePreference? _currentPreference;
  // List<RidePreference> pastPreferencesList = [];
  late AsyncValue<List<RidePreference>> pastPreferences;

  RidesPreferencesProvider({required this.ridePreferencesRepository}){
    pastPreferences = AsyncValue.loading();
    fetchPastPreferences();
  }

  RidePreference? get currentPreference => _currentPreference;


  Future<void> fetchPastPreferences() async {
    pastPreferences = AsyncValue.loading();
    notifyListeners();

    try {
      // Fetch data from the repository
      List<RidePreference> pastPrefs = await ridePreferencesRepository.getPastPreferences();
      pastPreferences = AsyncValue.success(pastPrefs);
    } catch (error) {
      // Handle error
      pastPreferences = AsyncValue.error(error);
    }

    notifyListeners();
  }

  Future<void> setCurrentPreference(RidePreference preference) async {
    if (_currentPreference == preference) {
      return; // Process only if the new preference is different
    }

    _currentPreference = preference;
    notifyListeners();

    // Add the preference to the repository and fetch updated data
    await _addPreference(preference);
  }
  Future<void> _addPreference(RidePreference preference) async {
    try {
      await ridePreferencesRepository.addPreference(preference);
      await fetchPastPreferences();
    } catch (error) {
      print("Error adding preference: $error");
    }
  }

}