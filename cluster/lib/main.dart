import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // For BoxShadow if needed.
import 'package:provider/provider.dart';

/// The telemetry model holds the state for all telemetry values.
class TelemetryModel extends ChangeNotifier {
  double _speed = 60;
  double _rpm = 3000;
  double _fuelLevel = 50;
  double _oilTemp = 180;
  double _coolantTemp = 190;
  double _oilPressure = 40;
  double _boostPressure = 10;
  double _airFuelRatio = 14.7;

  double get speed => _speed;
  set speed(double val) {
    _speed = val;
    notifyListeners();
  }

  double get rpm => _rpm;
  set rpm(double val) {
    _rpm = val;
    notifyListeners();
  }

  double get fuelLevel => _fuelLevel;
  set fuelLevel(double val) {
    _fuelLevel = val;
    notifyListeners();
  }

  double get oilTemp => _oilTemp;
  set oilTemp(double val) {
    _oilTemp = val;
    notifyListeners();
  }

  double get coolantTemp => _coolantTemp;
  set coolantTemp(double val) {
    _coolantTemp = val;
    notifyListeners();
  }

  double get oilPressure => _oilPressure;
  set oilPressure(double val) {
    _oilPressure = val;
    notifyListeners();
  }

  double get boostPressure => _boostPressure;
  set boostPressure(double val) {
    _boostPressure = val;
    notifyListeners();
  }

  double get airFuelRatio => _airFuelRatio;
  set airFuelRatio(double val) {
    _airFuelRatio = val;
    notifyListeners();
  }
}

/// A telemetry entry holds the label, value, unit, and min/max range.
class TelemetryEntry {
  final String label;
  final double value;
  final String unit;
  final double min;
  final double max;

  TelemetryEntry({
    required this.label,
    required this.value,
    required this.unit,
    required this.min,
    required this.max,
  });
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TelemetryModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  bool useSystemTheme = false;
  
  @override
  Widget build(BuildContext context) {
    // Retrieve system brightness.
    final systemBrightness = MediaQuery.of(context).platformBrightness;
    
    // When system theme is enabled, update isDarkMode to match the system.
    if (useSystemTheme && ((systemBrightness == Brightness.dark) != isDarkMode)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          isDarkMode = (systemBrightness == Brightness.dark);
        });
      });
    }
    
    final brightness = useSystemTheme
        ? systemBrightness
        : (isDarkMode ? Brightness.dark : Brightness.light);
    
    return CupertinoApp(
      theme: CupertinoThemeData(
        brightness: brightness,
      ),
      home: MainScreen(
        isDarkMode: isDarkMode,
        onThemeChanged: (bool newVal) {
          setState(() {
            isDarkMode = newVal;
          });
        },
        useSystemTheme: useSystemTheme,
        onUseSystemThemeChanged: (bool newVal) {
          setState(() {
            useSystemTheme = newVal;
          });
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final bool useSystemTheme;
  final ValueChanged<bool> onUseSystemThemeChanged;
  
  const MainScreen({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.useSystemTheme,
    required this.onUseSystemThemeChanged,
  }) : super(key: key);
  
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Control whether the control panel (menu bar) is open.
  bool controlPanelOpen = true;
  
  void toggleControlPanel() {
    setState(() {
      controlPanelOpen = !controlPanelOpen;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: null,
      child: SafeArea(
        child: Row(
          children: [
            // Gauge cluster area.
            Expanded(
              child: GaugeClusterWithToggle(
                onTogglePanel: toggleControlPanel,
              ),
            ),
            // Control panel area.
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: controlPanelOpen ? 300.0 : 0.0,
              child: controlPanelOpen
                  ? ControlPanel(
                      isDarkMode: widget.isDarkMode,
                      onThemeChanged: widget.onThemeChanged,
                      useSystemTheme: widget.useSystemTheme,
                      onUseSystemThemeChanged: widget.onUseSystemThemeChanged,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Combines the gauge cluster canvas with a toggle button.
class GaugeClusterWithToggle extends StatelessWidget {
  final VoidCallback onTogglePanel;
  
  const GaugeClusterWithToggle({
    Key? key,
    required this.onTogglePanel,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The gauge cluster canvas.
        const GaugeClusterCanvas(),
        // Toggle button at the top-right.
        Positioned(
          top: 16,
          right: 16,
          child: CupertinoButton(
            padding: const EdgeInsets.all(8),
            color: CupertinoColors.systemGrey,
            borderRadius: BorderRadius.circular(20),
            child: const Icon(CupertinoIcons.right_chevron, size: 20),
            onPressed: onTogglePanel,
          ),
        ),
      ],
    );
  }
}

/// The gauge cluster canvas containing the telemetry gauges.
class GaugeClusterCanvas extends StatelessWidget {
  const GaugeClusterCanvas({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Use the current theme’s scaffold background color.
    return Container(
      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
      child: const TelemetryDataGrid(),
    );
  }
}

/// Displays a grid of telemetry gauges (one for each telemetry entry).
class TelemetryDataGrid extends StatelessWidget {
  const TelemetryDataGrid({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final telemetry = Provider.of<TelemetryModel>(context);
    
    // Create telemetry entries with appropriate min/max ranges.
    List<TelemetryEntry> entries = [
      TelemetryEntry(label: "Speed", value: telemetry.speed, unit: "mph", min: 0, max: 150),
      TelemetryEntry(label: "RPM", value: telemetry.rpm, unit: "rpm", min: 0, max: 8000),
      TelemetryEntry(label: "Fuel Level", value: telemetry.fuelLevel, unit: "%", min: 0, max: 100),
      TelemetryEntry(label: "Oil Temp", value: telemetry.oilTemp, unit: "°F", min: 0, max: 300),
      TelemetryEntry(label: "Coolant Temp", value: telemetry.coolantTemp, unit: "°F", min: 0, max: 300),
      TelemetryEntry(label: "Oil Pressure", value: telemetry.oilPressure, unit: "psi", min: 0, max: 100),
      TelemetryEntry(label: "Boost Pressure", value: telemetry.boostPressure, unit: "psi", min: 0, max: 50),
      TelemetryEntry(label: "Air/Fuel Ratio", value: telemetry.airFuelRatio, unit: "", min: 10, max: 20),
    ];
    
    return GridView.count(
      crossAxisCount: 4,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: entries
          .map((entry) => TelemetryGridTile(entry: entry))
          .toList(),
    );
  }
}

/// A telemetry grid tile that displays a gauge face.
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

/// A circular gauge widget that displays a partial circular (240°) arc,
/// numeric value (with unit) in the center, and the label in the open bottom gap.
/// The gauge size has been increased to 360×360.
class CircularGauge extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final String unit;
  final String label;
  
  const CircularGauge({
    Key? key,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.label,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 360,
      child: Stack(
        children: [
          // The gauge arc.
          CustomPaint(
            size: const Size(360, 360),
            painter: GaugePainter(value: value, min: min, max: max),
          ),
          // Center numeric value with unit.
          Center(
            child: Text(
              "${value.toStringAsFixed(0)} $unit",
              style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          // Label positioned in the open gap at the bottom.
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                label,
                style: CupertinoTheme.of(context).textTheme.textStyle.copyWith(
                      fontSize: 20,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter that draws the gauge arc.
class GaugePainter extends CustomPainter {
  final double value;
  final double min;
  final double max;
  
  GaugePainter({
    required this.value,
    required this.min,
    required this.max,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = 16.0; // Increased for the larger gauge.
    final radius = (size.width / 2) - strokeWidth;
    
    // Define the arc: start at 150° and sweep 240°.
    final startAngle = 150 * 3.141592653589793 / 180;
    final totalSweep = 240 * 3.141592653589793 / 180;
    final fraction = ((value - min) / (max - min)).clamp(0.0, 1.0);
    final filledSweep = totalSweep * fraction;
    
    // Background arc (full gauge).
    final backgroundPaint = Paint()
      ..color = CupertinoColors.systemGrey4
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
      
    // Filled portion of the arc.
    final foregroundPaint = Paint()
      ..color = CupertinoColors.activeBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
      
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      totalSweep,
      false,
      backgroundPaint,
    );
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      filledSweep,
      false,
      foregroundPaint,
    );
  }
  
  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) {
    return oldDelegate.value != value ||
           oldDelegate.min != min ||
           oldDelegate.max != max;
  }
}

/// The ControlPanel widget provides Cupertino-styled controls to adjust telemetry values,
/// and (at the bottom) controls for theme selection.
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
                    child: Text(
                      "Controls",
                      style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                    ),
                  ),
                  // Telemetry control sliders.
                  const TelemetrySlider(label: "Speed", min: 0, max: 150),
                  const TelemetrySlider(label: "RPM", min: 0, max: 8000),
                  const TelemetrySlider(label: "Fuel Level", min: 0, max: 100),
                  const TelemetrySlider(label: "Oil Temp", min: 0, max: 300),
                  const TelemetrySlider(label: "Coolant Temp", min: 0, max: 300),
                  const TelemetrySlider(label: "Oil Pressure", min: 0, max: 100),
                  const TelemetrySlider(label: "Boost Pressure", min: 0, max: 50),
                  const TelemetrySlider(label: "Air/Fuel Ratio", min: 10, max: 20),
                ],
              ),
            ),
          ),
          // Bottom controls for theme selection.
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Use System Theme switch.
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
                // Dark Mode switch.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Dark Mode",
                        style: CupertinoTheme.of(context).textTheme.textStyle),
                    CupertinoSwitch(
                      value: useSystemTheme
                          ? (MediaQuery.of(context).platformBrightness == Brightness.dark)
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

/// A reusable telemetry slider widget to adjust telemetry values.
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
