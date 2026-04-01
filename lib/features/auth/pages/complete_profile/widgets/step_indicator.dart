import 'package:flutter/material.dart';
import 'package:myelvasense/core/core.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    required this.currentStep,
    required this.totalSteps,
    super.key,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: Dimens.space24),
    child: Row(
      children: List.generate(
        totalSteps,
        (index) => Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(right: index < totalSteps - 1 ? 4 : 0),
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: index <= currentStep
                  ? const Color(0xff38BDF8)
                  : const Color(0xff465566),
            ),
          ),
        ),
      ),
    ),
  );
}
