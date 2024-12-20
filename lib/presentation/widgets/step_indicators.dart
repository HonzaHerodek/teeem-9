import 'package:flutter/material.dart';
import '../../data/models/post_model.dart';
import 'step_indicators/step_dots.dart';
import 'step_indicators/step_miniatures.dart';

class StepIndicators extends StatefulWidget {
  final List<PostStep> steps;
  final int currentStep;
  final PageController pageController;
  final bool isExpanded;
  final bool showMiniatures;
  final Function(bool) onHeaderExpandChanged;
  final VoidCallback onTransformToMiniatures;
  final VoidCallback? onTransformToDots;

  const StepIndicators({
    Key? key,
    required this.steps,
    required this.currentStep,
    required this.pageController,
    required this.isExpanded,
    required this.showMiniatures,
    required this.onHeaderExpandChanged,
    required this.onTransformToMiniatures,
    this.onTransformToDots,
  }) : super(key: key);

  @override
  State<StepIndicators> createState() => _StepIndicatorsState();
}

class _StepIndicatorsState extends State<StepIndicators> {
  bool get _shouldShowMiniatures => 
      widget.isExpanded || (widget.showMiniatures && !_isFirstOrLastStep);

  bool get _isFirstOrLastStep =>
      widget.currentStep == 0 || widget.currentStep == widget.steps.length - 1;

  void _handleStepTap(int index) {
    if (_shouldShowMiniatures) {
      if (index == widget.currentStep && widget.onTransformToDots != null) {
        widget.onTransformToDots!();
      } else {
        widget.pageController.jumpToPage(index);
      }
    } else if (index != 0 && index != widget.steps.length - 1) {
      widget.onTransformToMiniatures();
    }
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    if (_isFirstOrLastStep && details.delta.dy > 0) {
      widget.onHeaderExpandChanged(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _shouldShowMiniatures
          ? StepMiniatures(
              key: const ValueKey('miniatures'),
              steps: widget.steps,
              currentStep: widget.currentStep,
              onExpand: () => widget.onHeaderExpandChanged(false),
              pageController: widget.pageController,
              onTransformToDots: widget.onTransformToDots,
            )
          : StepDots(
              key: const ValueKey('dots'),
              steps: widget.steps,
              currentStep: widget.currentStep,
              onExpand: () => widget.onHeaderExpandChanged(true),
              onMiniaturize: widget.onTransformToMiniatures,
            ),
    );
  }
}
