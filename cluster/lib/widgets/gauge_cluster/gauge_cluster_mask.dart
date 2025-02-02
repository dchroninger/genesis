import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class GaugeClusterMask extends StatelessWidget {
  final Widget child;

  /// The aspect ratio for the mask. Defaults to 21:9.
  final double aspectRatio;

  const GaugeClusterMask({
    Key? key,
    required this.child,
    this.aspectRatio = 26 / 9,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the maximum size that fits within the constraints with the desired aspect ratio.
        double maxWidth = constraints.maxWidth;
        double maxHeight = constraints.maxHeight;

        // Determine the size of the mask based on the desired aspect ratio.
        double maskWidth, maskHeight;
        if (maxWidth / maxHeight > aspectRatio) {
          // Too wide: height is the limiting factor.
          maskHeight = maxHeight;
          maskWidth = maskHeight * aspectRatio;
        } else {
          // Too tall: width is the limiting factor.
          maskWidth = maxWidth;
          maskHeight = maskWidth / aspectRatio;
        }

        // Center the mask within the available space.
        final left = (constraints.maxWidth - maskWidth) / 2;
        final top = (constraints.maxHeight - maskHeight) / 2;
        final maskRect = Rect.fromLTWH(left, top, maskWidth, maskHeight);

        return ClipPath(
          clipper: _GaugeClusterClipper(maskRect),
          child: child,
        );
      },
    );
  }
}

class _GaugeClusterClipper extends CustomClipper<Path> {
  final Rect maskRect;

  _GaugeClusterClipper(this.maskRect);

  @override
  Path getClip(Size size) {
    // Create a pill shape from the calculated maskRect.
    final path = Path();
    // For a pill shape, the radius should be half of the mask's height.
    final radius = maskRect.height / 2;
    path.addRRect(RRect.fromRectAndRadius(maskRect, Radius.circular(radius)));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
