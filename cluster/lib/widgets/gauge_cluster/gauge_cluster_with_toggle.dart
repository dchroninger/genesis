import 'package:flutter/cupertino.dart';

import 'gauge_cluster_canvas.dart';

class GaugeClusterWithToggle extends StatelessWidget {
  final VoidCallback onTogglePanel;

  const GaugeClusterWithToggle({
    Key? key,
    required this.onTogglePanel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The gauge cluster canvas.
        const GaugeClusterCanvas(),
        // Toggle button at the top-right.
        Positioned(
          top: 16,
          right: 16,
          child: CupertinoButton(
            padding: const EdgeInsets.all(8),
            color: CupertinoColors.systemGrey,
            borderRadius: BorderRadius.circular(20),
            onPressed: onTogglePanel,
            child: const Icon(CupertinoIcons.right_chevron, size: 20),
          ),
        ),
      ],
    );
  }
}
