import 'package:flutter/material.dart';
import 'package:safe_hi/util/responsive.dart';

class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressBar({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index % 2 == 0) {
          final stepIndex = index ~/ 2 + 1;
          return _buildStepCircle(context, stepIndex);
        } else {
          final beforeStep = (index ~/ 2) + 1;
          return _buildStepLine(beforeStep < currentStep);
        }
      }),
    );
  }

  Widget _buildStepCircle(BuildContext context, int stepIndex) {
    final responsive = Responsive(context);
    final isCompleted = stepIndex < currentStep;
    final isCurrent = stepIndex == currentStep;

    late Color fillColor;
    late Color borderColor;
    late Widget child;

    if (isCompleted) {
      fillColor = const Color(0xFFFB5457);
      borderColor = const Color(0xFFFB5457);
      child = Icon(
        Icons.check,
        size: responsive.fontSmall,
        color: Colors.white,
      );
    } else if (isCurrent) {
      fillColor = const Color(0xFFFB5457);
      borderColor = const Color(0xFFFB5457);
      child = Text(
        '$stepIndex',
        style: TextStyle(
          color: Colors.white,
          fontSize: responsive.fontSmall,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      fillColor = Colors.white;
      borderColor = const Color(0xFFFDD8DA);
      child = Text(
        '$stepIndex',
        style: TextStyle(
          color: const Color(0xFFFDD8DA),
          fontSize: responsive.fontSmall,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Container(
      width: responsive.iconSize * 0.9,
      height: responsive.iconSize * 0.9,
      margin: EdgeInsets.symmetric(
          horizontal: responsive.itemSpacing / 2,
          vertical: responsive.itemSpacing),
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? const Color(0xFFFB5457) : const Color(0xFFFDD8DA),
      ),
    );
  }
}

class ReportStepHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String stepTitle;
  final String stepSubtitle;

  const ReportStepHeader({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepTitle,
    required this.stepSubtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Column(
      children: [
        StepProgressBar(
          currentStep: currentStep,
          totalSteps: totalSteps,
        ),
        SizedBox(height: responsive.itemSpacing),
        Text(
          stepTitle,
          style: TextStyle(
            fontSize: responsive.fontBase,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFFB5457),
          ),
        ),
        SizedBox(height: responsive.itemSpacing / 2),
        Text(
          stepSubtitle,
          style: TextStyle(
            fontSize: responsive.fontLarge,
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
