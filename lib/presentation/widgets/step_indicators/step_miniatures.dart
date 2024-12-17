import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../../../core/utils/step_type_utils.dart';
import '../../../core/utils/step_indicators_utils.dart';

class StepMiniatures extends StatefulWidget {
  final List<PostStep> steps;
  final int currentStep;
  final VoidCallback onExpand;
  final VoidCallback? onTransformToDots;
  final PageController pageController;
  final bool showSelection;
  final bool centerBetweenFirstTwo;

  const StepMiniatures({
    Key? key,
    required this.steps,
    required this.currentStep,
    required this.onExpand,
    required this.pageController,
    this.onTransformToDots,
    this.showSelection = true,
    this.centerBetweenFirstTwo = false,
  }) : super(key: key);

  @override
  State<StepMiniatures> createState() => _StepMiniaturesState();
}

class _StepMiniaturesState extends State<StepMiniatures> {
  late final ScrollController _scrollController;
  bool _isInExpandedHeader = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _isInExpandedHeader = widget.onTransformToDots == null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.centerBetweenFirstTwo) {
        _centerBetweenFirstTwo(animate: false);
      } else {
        _centerCurrentStep(animate: false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StepMiniatures oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep != oldWidget.currentStep && !widget.centerBetweenFirstTwo) {
      _centerCurrentStep(animate: true);
    }
  }

  void _centerCurrentStep({required bool animate}) {
    StepIndicatorsUtils.centerScrollToItem(
      scrollController: _scrollController,
      currentStep: widget.currentStep,
      totalSteps: widget.steps.length,
      itemWidth: 72.0,
      animate: animate,
    );
  }

  void _centerBetweenFirstTwo({required bool animate}) {
    if (widget.steps.length < 2) return;
    
    final itemWidth = 72.0;
    final offset = itemWidth * 0.5; // Half of first miniature width
    
    if (animate) {
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _scrollController.jumpTo(offset);
    }
  }

  void _handleStepTap(int index) {
    if (index == widget.currentStep && !_isInExpandedHeader) {
      widget.onTransformToDots?.call();
      return;
    }

    if (_isInExpandedHeader) {
      widget.onExpand();
    }

    widget.pageController.jumpToPage(index);
  }

  List<BoxShadow> _createDiffusedShadows(Color color, bool isSelected) {
    if (!widget.showSelection) {
      return [];
    }

    final baseShadows = [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 40,
        spreadRadius: 25,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 30,
        spreadRadius: 20,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 20,
        spreadRadius: 15,
      ),
    ];

    if (isSelected) {
      baseShadows.addAll([
        BoxShadow(
          color: color.withOpacity(0.2),
          blurRadius: 50,
          spreadRadius: 30,
        ),
        BoxShadow(
          color: color.withOpacity(0.25),
          blurRadius: 40,
          spreadRadius: 25,
        ),
        BoxShadow(
          color: color.withOpacity(0.3),
          blurRadius: 30,
          spreadRadius: 20,
        ),
      ]);
    }

    return baseShadows;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = 72.0;
          final screenWidth = constraints.maxWidth;
          final totalContentWidth = widget.steps.length * itemWidth;
          final sidePadding = totalContentWidth <= screenWidth
              ? (screenWidth - totalContentWidth) / 2
              : itemWidth / 2;

          return SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sidePadding),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.steps.length,
                  (index) {
                    final color = StepTypeUtils.getColorForStepType(
                        widget.steps[index].type);
                    final icon = StepTypeUtils.getIconForStepType(
                        widget.steps[index].type);
                    final isSelected = index == widget.currentStep;

                    return _buildStepMiniature(
                      index: index,
                      color: color,
                      icon: icon,
                      isSelected: isSelected,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepMiniature({
    required int index,
    required Color color,
    required IconData icon,
    required bool isSelected,
  }) {
    final opacity = widget.showSelection ? (isSelected ? 1.0 : 0.9) : 0.9;

    return InkWell(
      onTap: () => _handleStepTap(index),
      child: Container(
        width: 72.0,
        height: 72.0,
        alignment: Alignment.center,
        child: Container(
          width: 64.0,
          height: 64.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: _createDiffusedShadows(color, isSelected),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: color.withOpacity(opacity),
                  size: 24,
                ),
                const SizedBox(height: 2),
                Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: color.withOpacity(opacity),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
