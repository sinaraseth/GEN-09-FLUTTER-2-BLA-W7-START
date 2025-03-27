import 'package:flutter/foundation.dart'; // Required for ChangeNotifier
import 'package:week_3_blabla_project/model/ride/ride_pref.dart';
import 'package:week_3_blabla_project/repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  final RidePreferencesRepository ridePreferencesRepository;

  RidePreference? _currentPreference;
  List<RidePreference> pastPreferencesList = [];

  RidesPreferencesProvider({required this.ridePreferencesRepository});

  RidePreference? get currentPreference {
    return _currentPreference;
  }

  List<RidePreference> get pastPreferences {
    return List.unmodifiable(pastPreferencesList.reversed);
  }

  void setCurrentPreference(RidePreference preference) {
    if (_currentPreference == preference) {
      return; // Process only if the new preference is different
    }

    // Update the current preference
    _currentPreference = preference;

    // Update the history, ensuring all preferences are unique
    if (!pastPreferencesList.contains(preference)) {
      pastPreferencesList.add(preference);
    }

    // Notify listeners about the changes
    notifyListeners();

    print("Set current pref to $_currentPreference");
  }
}