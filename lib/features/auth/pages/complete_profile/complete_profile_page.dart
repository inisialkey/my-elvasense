import 'package:flutter/material.dart';
import 'package:myelvasense/core/core.dart';
import 'package:myelvasense/features/features.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  void _nextPage() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) => Parent(
    appBar: MyAppBar(onBack: _currentStep > 0 ? _previousPage : null),
    child: Column(
      children: [
        StepIndicator(currentStep: _currentStep, totalSteps: _totalSteps),

        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              YourNameStep(onNext: _nextPage),
              DateBirthStep(onNext: _nextPage),
              HeightStep(onNext: _nextPage),
              WeightStep(onNext: _nextPage),
            ],
          ),
        ),
      ],
    ),
  );
}
