import 'package:flutter/material.dart';

/// Shows "Step X of 5" plus a linear progress indicator.
/// Drop this at the top of each wizard screen's body.
class LAProgressBar extends StatelessWidget {
  final int currentStep; // 1-based
  final int totalSteps;
  final String stepLabel;

  const LAProgressBar({
    Key? key,
    required this.currentStep,
    required this.stepLabel,
    this.totalSteps = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step $currentStep of $totalSteps',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                stepLabel,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: currentStep / totalSteps,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
            ),
          ),
        ],
      ),
    );
  }
}