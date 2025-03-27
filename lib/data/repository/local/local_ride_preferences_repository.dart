import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/ride/ride_pref.dart';
import '../../dto/ride_pref_dto.dart';
import '../ride_preferences_repository.dart';

class LocalRidePreferencesRepository implements RidePreferencesRepository {
  static const String _preferencesKey = "ride_preferences";

  @override
  Future<List<RidePreference>> getPastPreferences() async {
    // Get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();

    // Get the string list from the key
    final prefsList = prefs.getStringList(_preferencesKey) ?? [];

    // Convert the string list to a list of RidePreferences
    return prefsList
        .map((json) => RidePreferenceDto.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<void> addPreference(RidePreference preference) async {
    // Get the current list of preferences
    final currentPreferences = await getPastPreferences();

    // Add the new preference
    currentPreferences.add(preference);

    // Save the updated list as a string list
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _preferencesKey,
      currentPreferences
          .map((pref) => jsonEncode(RidePreferenceDto.toJson(pref)))
          .toList(),
    );
  }
}