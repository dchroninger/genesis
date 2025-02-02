import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'models/telemetry_model.dart';
import 'models/cluster_state_model.dart';
import 'screens/gauge_cluster_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TelemetryModel()),
        ChangeNotifierProvider(create: (_) => ClusterStateModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
    if (useSystemTheme &&
        ((systemBrightness == Brightness.dark) != isDarkMode)) {
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
      home: GaugeClusterScreen(
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
