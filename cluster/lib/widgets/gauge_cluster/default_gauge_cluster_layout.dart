import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'gauge_cluster_mask.dart';
import '../circular_gauge.dart';
import 'indicator_cluster.dart';
import '../../models/telemetry_model.dart';

class DefaultGaugeClusterLayout extends StatelessWidget {
  const DefaultGaugeClusterLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap the entire layout in the gauge cluster mask.
    return GaugeClusterMask(
      child: Container(
        // Use darkBackgroundGray for the cluster background.
        color: CupertinoColors.darkBackgroundGray,
        // Use a fixed padding to ensure the gauges are just inside the mask.
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left gauge: Speedometer.
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Consumer<TelemetryModel>(
                  builder: (context, telemetry, child) => CircularGauge(
                    value: telemetry.speed,
                    min: 0,
                    max: 150,
                    unit: "mph",
                    label: "Speed",
                  ),
                ),
              ),
            ),
            // Center cluster: Indicator cluster.
            const Expanded(
              child: Center(
                child: IndicatorCluster(),
              ),
            ),
            // Right gauge: Tachometer.
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Consumer<TelemetryModel>(
                  builder: (context, telemetry, child) => CircularGauge(
                    value: telemetry.rpm,
                    min: 0,
                    max: 8000,
                    unit: "rpm",
                    label: "RPM",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
