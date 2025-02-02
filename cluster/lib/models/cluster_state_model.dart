import 'package:flutter/foundation.dart';

enum IndicatorSelection { left, right, hazard, none }

class ClusterStateModel extends ChangeNotifier {
  // Status indicators.
  bool checkEngineLight = false;
  bool highBeams = false;
  bool lowFuel = false;
  bool lowVoltage = false;
  bool oilPressure = false;
  
  // Indicator lights radio selection.
  IndicatorSelection indicatorSelection = IndicatorSelection.none;
  
  // Toggle for inactive indicator visibility (true = show at low opacity, false = hide).
  bool showInactiveIndicators = true;
  
  // Gauge style selection.
  String gaugeStyle = "Default";
  
  // New fields for odometer (ODO) and trip length.
  String odometer = "00000"; // Mileage.
  String trip = "000.0";     // Trip length.
  
  void setCEL(bool val) {
    checkEngineLight = val;
    notifyListeners();
  }
  
  void setHighBeams(bool val) {
    highBeams = val;
    notifyListeners();
  }
  
  void setLowFuel(bool val) {
    lowFuel = val;
    notifyListeners();
  }
  
  void setLowVoltage(bool val) {
    lowVoltage = val;
    notifyListeners();
  }
  
  void setOilPressure(bool val) {
    oilPressure = val;
    notifyListeners();
  }
  
  void setIndicatorSelection(IndicatorSelection selection) {
    indicatorSelection = selection;
    notifyListeners();
  }
  
  void setShowInactiveIndicators(bool val) {
    showInactiveIndicators = val;
    notifyListeners();
  }
  
  void setGaugeStyle(String style) {
    gaugeStyle = style;
    notifyListeners();
  }
  
  void setOdometer(String odo) {
    odometer = odo;
    notifyListeners();
  }
  
  void setTrip(String t) {
    trip = t;
    notifyListeners();
  }
}
