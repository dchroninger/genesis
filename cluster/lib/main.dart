import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Flexible(
                    child: GaugeCircle(
                        startDegree: 190,
                        endDegree: 50,
                        units: "km/h",
                        value: 80.0,
                        maxValue: 120.0,
                        size: 450,
                        stat: Stat(units: "km", value: 120.0, maxValue: 120.0)),
                  ),
                  Padding(
                    // NOTE: This logo should eventually become the indicator compontent.
                    // Turn and Hazard indicators will be the lower wing sections.
                    // Entire logo dimly lights up when headlights are on.
                    // Central crest will illuminate when the high beams are active.
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: SizedBox(
                      width: 430,
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.matrix([
                          -1, 0, 0, 0, 255, // Red
                          0, -1, 0, 0, 255, // Green
                          0, 0, -1, 0, 255, // Blue
                          0, 0, 0, 0.2, 0, // Alpha
                        ]),
                        child: Image.asset(
                          'assets/genesis.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const Flexible(
                    child: GaugeCircle(
                        startDegree: 310,
                        endDegree: 170,
                        units: "RPM",
                        value: 4700.0,
                        maxValue: 8500.0,
                        size: 450),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GaugeCircle extends StatelessWidget {
  final String units;
  final double value;
  final double maxValue;
  final double size;
  final double startDegree;
  final double endDegree;
  final Stat? stat; // Optional stat parameter

  const GaugeCircle({
    Key? key,
    required this.units,
    required this.value,
    required this.maxValue,
    required this.size,
    required this.startDegree,
    required this.endDegree,
    this.stat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var percentage = value / maxValue;

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: GaugePainter(
          percentage: percentage,
          startDegree: startDegree,
          endDegree: endDegree,
          stat: stat,
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value.toStringAsFixed(0),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 62,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                units,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Stat {
  final String units;
  final double value;
  final double maxValue;

  const Stat(
      {required this.units, required this.value, required this.maxValue});
}

class GaugePainter extends CustomPainter {
  final double percentage;
  final double startDegree;
  final double endDegree;
  final Stat? stat;

  GaugePainter({
    required this.percentage,
    required this.startDegree,
    required this.endDegree,
    this.stat,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Normalize degrees and ensure clockwise direction
    final normalizedStart = startDegree % 360;
    var normalizedEnd = endDegree % 360;
    if (normalizedEnd <= normalizedStart) {
      normalizedEnd += 360; // Wrap around to ensure clockwise direction
    }

    // Active and inactive sweeps
    final activeSweep = (normalizedEnd - normalizedStart) * percentage;
    final inactiveSweep = (normalizedEnd - normalizedStart) - activeSweep;

    // Calculate start and sweep angles in radians
    final startAngle = (normalizedStart - 90) * (pi / 180);
    final sweepAngle = (normalizedEnd - normalizedStart) * (pi / 180);

    // Draw the glow effect
    final glowRadius = radius + 20; // Slightly larger than the gauge
    final glowGradient = RadialGradient(
      colors: [
        Colors.blue.withOpacity(0.5), // Vibrant color at the center
        Colors.transparent, // Fade to transparent at the edges
      ],
      stops: const [0.0, 1.0],
    );

    final glowPaint = Paint()
      ..shader = glowGradient.createShader(
        Rect.fromCircle(center: center, radius: glowRadius),
      );
    canvas.drawCircle(center, glowRadius, glowPaint);

    // Draw background arc
    final backgroundPaint = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    // Draw foreground arc
    final foregroundPaint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      activeSweep * (pi / 180),
      false,
      foregroundPaint,
    );

    // Draw stat if available
    if (stat != null) {
      final statPercentage = stat!.value / stat!.maxValue;

      // Calculate midpoint of inactive section
      final statMidpointDegree =
          (normalizedStart + activeSweep / 2 + inactiveSweep / 2) - 270;
      final statStartAngle = (statMidpointDegree - 25) *
          (pi / 180); // Subtract 90 for top alignment
      final statSweepAngle =
          (50 * statPercentage) * (pi / 180); // Stat spans 30 degrees max

      final statPaint = Paint()
        ..color = Colors.lightBlue
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 10;
      canvas.drawArc(
        Rect.fromCircle(
            center: center, radius: radius), // Inner radius for separation
        statStartAngle,
        statSweepAngle,
        false,
        statPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
