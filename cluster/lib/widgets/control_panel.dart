import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'telemetry_slider.dart';
import '../models/cluster_state_model.dart';

class ControlPanel extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final bool useSystemTheme;
  final ValueChanged<bool> onUseSystemThemeChanged;

  const ControlPanel({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.useSystemTheme,
    required this.onUseSystemThemeChanged,
  }) : super(key: key);

  void _showGaugeStylePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text("Select Gauge Layout"),
          actions: <Widget>[
            CupertinoActionSheetAction(
              onPressed: () {
                Provider.of<ClusterStateModel>(context, listen: false)
                    .setGaugeStyle("Default");
                Navigator.pop(context);
              },
              child: const Text("Default"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Provider.of<ClusterStateModel>(context, listen: false)
                    .setGaugeStyle("Data Grid");
                Navigator.pop(context);
              },
              child: const Text("Data Grid"),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
        );
      },
    );
  }

  Widget _buildSwitchRow(BuildContext context, String label, bool value,
      ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: CupertinoTheme.of(context).textTheme.textStyle),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String placeholder,
      ValueChanged<String> onChanged) {
    return CupertinoTextField(
      placeholder: placeholder,
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = CupertinoTheme.of(context).brightness;
    final panelColor = brightness == Brightness.dark
        ? CupertinoColors.black
        : CupertinoColors.systemGrey6;
    final headerColor = brightness == Brightness.dark
        ? CupertinoColors.darkBackgroundGray
        : CupertinoColors.systemGrey4;

    return Container(
      color: panelColor,
      child: Column(
        children: [
          // Expanded area for telemetry controls.
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header for the control panel.
                  Container(
                    color: headerColor,
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      "Controls",
                      style:
                          TextStyle(fontSize: 20, color: CupertinoColors.white),
                    ),
                  ),
                  // Telemetry sliders arranged in rows of 2.
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        SizedBox(
                          width: 220,
                          child:
                              TelemetrySlider(label: "Speed", min: 0, max: 150),
                        ),
                        SizedBox(
                          width: 220,
                          child:
                              TelemetrySlider(label: "RPM", min: 0, max: 8000),
                        ),
                        SizedBox(
                          width: 220,
                          child: TelemetrySlider(
                              label: "Fuel Level", min: 0, max: 100),
                        ),
                        SizedBox(
                          width: 220,
                          child: TelemetrySlider(
                              label: "Oil Temp", min: 0, max: 300),
                        ),
                        SizedBox(
                          width: 220,
                          child: TelemetrySlider(
                              label: "Coolant Temp", min: 0, max: 300),
                        ),
                        SizedBox(
                          width: 220,
                          child: TelemetrySlider(
                              label: "Oil Pressure", min: 0, max: 100),
                        ),
                        SizedBox(
                          width: 220,
                          child: TelemetrySlider(
                              label: "Boost Pressure", min: 0, max: 50),
                        ),
                        SizedBox(
                          width: 220,
                          child: TelemetrySlider(
                              label: "Air/Fuel Ratio", min: 10, max: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Row for ODO and Trip text fields.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildTextField(context, "ODO", (value) {
                            Provider.of<ClusterStateModel>(context,
                                    listen: false)
                                .setOdometer(value);
                          }),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(context, "Trip", (value) {
                            Provider.of<ClusterStateModel>(context,
                                    listen: false)
                                .setTrip(value);
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Gauge style drop down.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CupertinoButton(
                      color: headerColor,
                      onPressed: () => _showGaugeStylePicker(context),
                      child: Consumer<ClusterStateModel>(
                        builder: (context, clusterState, child) {
                          return Text(
                            "Gauge Style: ${clusterState.gaugeStyle}",
                            style:
                                const TextStyle(color: CupertinoColors.white),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Status indicator checkboxes.
                  Container(
                    color: headerColor,
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      "Status Indicators",
                      style:
                          TextStyle(fontSize: 16, color: CupertinoColors.white),
                    ),
                  ),
                  _buildSwitchRow(
                      context,
                      "CEL",
                      Provider.of<ClusterStateModel>(context).checkEngineLight,
                      (bool val) =>
                          Provider.of<ClusterStateModel>(context, listen: false)
                              .setCEL(val)),
                  _buildSwitchRow(
                      context,
                      "High Beams",
                      Provider.of<ClusterStateModel>(context).highBeams,
                      (bool val) =>
                          Provider.of<ClusterStateModel>(context, listen: false)
                              .setHighBeams(val)),
                  _buildSwitchRow(
                      context,
                      "Low Fuel",
                      Provider.of<ClusterStateModel>(context).lowFuel,
                      (bool val) =>
                          Provider.of<ClusterStateModel>(context, listen: false)
                              .setLowFuel(val)),
                  _buildSwitchRow(
                      context,
                      "Low Voltage",
                      Provider.of<ClusterStateModel>(context).lowVoltage,
                      (bool val) =>
                          Provider.of<ClusterStateModel>(context, listen: false)
                              .setLowVoltage(val)),
                  _buildSwitchRow(
                      context,
                      "Oil Pressure",
                      Provider.of<ClusterStateModel>(context).oilPressure,
                      (bool val) =>
                          Provider.of<ClusterStateModel>(context, listen: false)
                              .setOilPressure(val)),
                  const SizedBox(height: 16),
                  // Toggle for inactive indicator visibility.
                  _buildSwitchRow(
                      context,
                      "Show Inactive Indicators",
                      Provider.of<ClusterStateModel>(context)
                          .showInactiveIndicators,
                      (bool val) =>
                          Provider.of<ClusterStateModel>(context, listen: false)
                              .setShowInactiveIndicators(val)),
                ],
              ),
            ),
          ),
          // Bottom controls for theme selection.
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Use System Theme",
                        style: CupertinoTheme.of(context).textTheme.textStyle),
                    CupertinoSwitch(
                      value: useSystemTheme,
                      onChanged: onUseSystemThemeChanged,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Dark Mode",
                        style: CupertinoTheme.of(context).textTheme.textStyle),
                    CupertinoSwitch(
                      value: useSystemTheme
                          ? (MediaQuery.of(context).platformBrightness ==
                              Brightness.dark)
                          : isDarkMode,
                      onChanged: useSystemTheme ? null : onThemeChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
