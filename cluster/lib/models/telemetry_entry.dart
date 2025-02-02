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
