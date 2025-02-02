import 'package:flutter/cupertino.dart';

import 'telemetry_data_grid.dart';

class GaugeClusterCanvas extends StatelessWidget {
  const GaugeClusterCanvas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the current theme’s scaffold background color.
    return Container(
      color: CupertinoTheme.of(context).scaffoldBackgroundColor,
      child: const Padding(
        padding: EdgeInsets.all(160),
        child: TelemetryDataGrid(),
      ),
    );
  }
}
