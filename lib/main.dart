import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repository/mock/mock_locations_repository.dart';
import 'data/repository/mock/mock_rides_repository.dart';
import 'data/repository/mock/mock_ride_preferences_repository.dart';
import 'service/locations_service.dart';
import 'service/rides_service.dart';
import 'ui/screens/ride_pref/ride_pref_screen.dart';
import 'ui/theme/theme.dart';
import 'ui/providers/rides_preferences_provider.dart';

void main() {
  // 1 - Initialize the services
  LocationsService.initialize(MockLocationsRepository());
  RidesService.initialize(MockRidesRepository());

  // 2 - Run the UI
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Expose RidesPreferencesProvider
        ChangeNotifierProvider(
          create: (_) => RidesPreferencesProvider(
            ridePreferencesRepository: MockRidePreferencesRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const Scaffold(body: RidePrefScreen()),
      ),
    );
  }
}