import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/telemetry_model.dart';
import '../../models/telemetry_entry.dart';
import 'telemetry_grid_tile.dart';

class TelemetryDataGrid extends StatelessWidget {
  const TelemetryDataGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final telemetry = Provider.of<TelemetryModel>(context);

    // Create telemetry entries with appropriate min/max ranges.
    List<TelemetryEntry> entries = [
      TelemetryEntry(
          label: "Speed",
          value: telemetry.speed,
          unit: "mph",
          min: 0,
          max: 150),
      TelemetryEntry(
          label: "RPM", value: telemetry.rpm, unit: "rpm", min: 0, max: 8000),
      TelemetryEntry(
          label: "Fuel Level",
          value: telemetry.fuelLevel,
          unit: "%",
          min: 0,
          max: 100),
      TelemetryEntry(
          label: "Oil Temp",
          value: telemetry.oilTemp,
          unit: "°F",
          min: 0,
          max: 300),
      TelemetryEntry(
          label: "Coolant Temp",
          value: telemetry.coolantTemp,
          unit: "°F",
          min: 0,
          max: 300),
      TelemetryEntry(
          label: "Oil Pressure",
          value: telemetry.oilPressure,
          unit: "psi",
          min: 0,
          max: 100),
      TelemetryEntry(
          label: "Boost Pressure",
          value: telemetry.boostPressure,
          unit: "psi",
          min: 0,
          max: 50),
      TelemetryEntry(
          label: "Air/Fuel Ratio",
          value: telemetry.airFuelRatio,
          unit: "",
          min: 10,
          max: 20),
    ];

    return GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children:
          entries.map((entry) => TelemetryGridTile(entry: entry)).toList(),
    );
  }
}
