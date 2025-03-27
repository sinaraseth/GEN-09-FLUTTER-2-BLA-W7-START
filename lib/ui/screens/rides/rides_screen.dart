import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/ride/ride_filter.dart';
import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import '../../providers/rides_preferences_provider.dart';
import 'widgets/ride_pref_bar.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

///
/// The Ride Selection screen allows the user to select a ride, once ride preferences have been defined.
/// The screen also allows the user to re-define the ride preferences and activate some filters.
///
class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  void onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
    // 1 - Update the current preference using the provider
    final provider = context.read<RidesPreferencesProvider>();
    provider.setCurrentPreference(newPreference);
  }

  void onPreferencePressed(BuildContext context, RidePreference currentPreference) async {
    // Open a modal to edit the ride preferences
    RidePreference? newPreference = await Navigator.of(
      context,
    ).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      // 1 - Update the current preference using the provider
      final provider = context.read<RidesPreferencesProvider>();
      provider.setCurrentPreference(newPreference);
    }
  }

  void onFilterPressed() {
    // TODO: Implement filter functionality
  }

  @override
  Widget build(BuildContext context) {
    // Watch the RidesPreferencesProvider for changes
    final provider = context.watch<RidesPreferencesProvider>();
    final currentPreference = provider.currentPreference;

    // Get the list of available rides based on the current preference
    final matchingRides = currentPreference != null
        ? RidesService.instance.getRidesFor(currentPreference, RideFilter())
        : [];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search bar
            RidePrefBar(
              ridePreference: currentPreference!,
              onBackPressed: () => Navigator.of(context).pop(),
              onPreferencePressed: () => onPreferencePressed(context, currentPreference),
              onFilterPressed: onFilterPressed,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) =>
                    RideTile(ride: matchingRides[index], onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}