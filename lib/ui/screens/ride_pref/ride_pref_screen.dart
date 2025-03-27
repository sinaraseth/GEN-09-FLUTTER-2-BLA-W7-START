import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week_3_blabla_project/ui/providers/async_value.dart';

import '../../../model/ride/ride_pref.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import '../../providers/rides_preferences_provider.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  void onRidePrefSelected(
      BuildContext context, RidePreference newPreference) async {
    // 1 - Update the current preference using the provider
    final provider = context.read<RidesPreferencesProvider>();
    provider.setCurrentPreference(newPreference);

    // 2 - Navigate to the rides screen (with a bottom-to-top animation)
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(const RidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RidesPreferencesProvider>();
    final currentRidePreference = provider.currentPreference;
    final pastPreferences = provider.pastPreferences;

    Widget buildPastPreferences() {
      if (pastPreferences.state == AsyncValueState.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (pastPreferences.state == AsyncValueState.error) {
        return Center(child: Text('Error: ${pastPreferences.error}'));
      } else if (pastPreferences.state == AsyncValueState.success) {
        final preferences = pastPreferences.data!;
        return ListView.builder(
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: preferences.length,
          itemBuilder: (ctx, index) => RidePrefHistoryTile(
            ridePref: preferences[index],
            onPressed: () => onRidePrefSelected(context, preferences[index]),
          ),
        );
      }
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        const BlaBackground(),
        Column(
          children: [
            const SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 100),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RidePrefForm(
                    initialPreference: currentRidePreference,
                    onSubmit: (preference) =>
                        onRidePrefSelected(context, preference),
                  ),
                  const SizedBox(height: BlaSpacings.m),
                  SizedBox(height: 200, child: buildPastPreferences()),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
