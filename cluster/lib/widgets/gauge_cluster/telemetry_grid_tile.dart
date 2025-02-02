import 'package:flutter/cupertino.dart';

import '../../models/telemetry_entry.dart';
import '../circular_gauge.dart';

class TelemetryGridTile extends StatelessWidget {
  final TelemetryEntry entry;

  const TelemetryGridTile({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Center the gauge within the grid cell.
    return Center(
      child: CircularGauge(
        value: entry.value,
        min: entry.min,
        max: entry.max,
        unit: entry.unit,
        label: entry.label,
      ),
    );
  }
}
