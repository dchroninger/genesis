import 'package:flutter/cupertino.dart';

import '../widgets/gauge_cluster/default_gauge_cluster_layout.dart';
import '../widgets/control_panel.dart';

class GaugeClusterScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final bool useSystemTheme;
  final ValueChanged<bool> onUseSystemThemeChanged;

  const GaugeClusterScreen({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.useSystemTheme,
    required this.onUseSystemThemeChanged,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _GaugeClusterScreenState createState() => _GaugeClusterScreenState();
}

class _GaugeClusterScreenState extends State<GaugeClusterScreen> {
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
            // Gauge cluster area with the default layout.
            const Expanded(
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: DefaultGaugeClusterLayout()),
            ),
            // Control panel area: updated width to 450.0 (150% of 300).
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: controlPanelOpen ? 450.0 : 0.0,
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
