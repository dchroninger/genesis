import 'package:flutter/cupertino.dart';

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
    const strokeWidth = 16.0; // Increased for the larger gauge.
    final radius = (size.width / 2) - strokeWidth;

    // Define the arc: start at 150° and sweep 240°.
    const startAngle = 150 * 3.141592653589793 / 180;
    const totalSweep = 240 * 3.141592653589793 / 180;
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
