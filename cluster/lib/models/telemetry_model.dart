import 'package:flutter/foundation.dart';

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
