import 'package:flutter/cupertino.dart';

import 'gauge_painter.dart';

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
      width: 700,
      height: 700,
      child: Stack(
        children: [
          CustomPaint(
            size: const Size(700, 700),
            painter: GaugePainter(value: value, min: min, max: max),
          ),
          Center(
            child: Text(
              "${value.toStringAsFixed(0)} $unit",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: CupertinoColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
