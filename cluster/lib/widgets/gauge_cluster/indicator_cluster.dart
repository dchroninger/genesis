import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../models/cluster_state_model.dart';

class IndicatorCluster extends StatelessWidget {
  const IndicatorCluster({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clusterState = Provider.of<ClusterStateModel>(context);

    double inactiveOpacity = clusterState.showInactiveIndicators ? 0.05 : 0.0;

    Color indicatorColor(bool active) {
      return active
          ? CupertinoColors.white
          : CupertinoColors.white.withOpacity(inactiveOpacity);
    }

    bool leftIndicatorActive = false;
    bool rightIndicatorActive = false;
    switch (clusterState.indicatorSelection) {
      case IndicatorSelection.left:
        leftIndicatorActive = true;
        break;
      case IndicatorSelection.right:
        rightIndicatorActive = true;
        break;
      case IndicatorSelection.hazard:
        leftIndicatorActive = true;
        rightIndicatorActive = true;
        break;
      case IndicatorSelection.none:
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 280),
        // Turn signals row.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildIndicatorCircle(
              label: "Left",
              active: leftIndicatorActive,
              color: indicatorColor(leftIndicatorActive),
            ),
            _buildIndicatorCircle(
              label: "Right",
              active: rightIndicatorActive,
              color: indicatorColor(rightIndicatorActive),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Status indicators row.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSmallIndicator("CEL", clusterState.checkEngineLight,
                indicatorColor(clusterState.checkEngineLight)),
            _buildSmallIndicator("High", clusterState.highBeams,
                indicatorColor(clusterState.highBeams)),
            _buildSmallIndicator("Fuel", clusterState.lowFuel,
                indicatorColor(clusterState.lowFuel)),
            _buildSmallIndicator("Volt", clusterState.lowVoltage,
                indicatorColor(clusterState.lowVoltage)),
            _buildSmallIndicator("Oil", clusterState.oilPressure,
                indicatorColor(clusterState.oilPressure)),
          ],
        ),
        const SizedBox(height: 280),
        // Bottom row for ODO and Trip.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ODO: ${clusterState.odometer}",
                style:
                    const TextStyle(fontSize: 16, color: CupertinoColors.white),
              ),
              Text(
                "Trip: ${clusterState.trip}",
                style:
                    const TextStyle(fontSize: 16, color: CupertinoColors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIndicatorCircle(
      {required String label, required bool active, required Color color}) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, color: CupertinoColors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSmallIndicator(String label, bool active, Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 10, color: CupertinoColors.black),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
