import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/telemetry_model.dart';

class TelemetrySlider extends StatelessWidget {
  final String label;
  final double min;
  final double max;

  const TelemetrySlider({
    Key? key,
    required this.label,
    required this.min,
    required this.max,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final telemetry = Provider.of<TelemetryModel>(context);
    double value;
    void Function(double) updateValue;

    switch (label) {
      case "Speed":
        value = telemetry.speed;
        updateValue = (double newVal) => telemetry.speed = newVal;
        break;
      case "RPM":
        value = telemetry.rpm;
        updateValue = (double newVal) => telemetry.rpm = newVal;
        break;
      case "Fuel Level":
        value = telemetry.fuelLevel;
        updateValue = (double newVal) => telemetry.fuelLevel = newVal;
        break;
      case "Oil Temp":
        value = telemetry.oilTemp;
        updateValue = (double newVal) => telemetry.oilTemp = newVal;
        break;
      case "Coolant Temp":
        value = telemetry.coolantTemp;
        updateValue = (double newVal) => telemetry.coolantTemp = newVal;
        break;
      case "Oil Pressure":
        value = telemetry.oilPressure;
        updateValue = (double newVal) => telemetry.oilPressure = newVal;
        break;
      case "Boost Pressure":
        value = telemetry.boostPressure;
        updateValue = (double newVal) => telemetry.boostPressure = newVal;
        break;
      case "Air/Fuel Ratio":
        value = telemetry.airFuelRatio;
        updateValue = (double newVal) => telemetry.airFuelRatio = newVal;
        break;
      default:
        value = 0;
        updateValue = (double newVal) {};
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ${value.toStringAsFixed(1)}",
            style: CupertinoTheme.of(context).textTheme.textStyle,
          ),
          CupertinoSlider(
            min: min,
            max: max,
            value: value,
            onChanged: updateValue,
          ),
        ],
      ),
    );
  }
}
