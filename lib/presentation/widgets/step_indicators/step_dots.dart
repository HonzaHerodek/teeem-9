import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../../../core/utils/step_type_utils.dart';
import '../../../core/utils/step_indicators_utils.dart';

class StepDots extends StatefulWidget {
  final List<PostStep> steps;
  final int currentStep;
  final VoidCallback onExpand;
  final VoidCallback onMiniaturize;

  const StepDots({
    Key? key,
    required this.steps,
    required this.currentStep,
    required this.onExpand,
    required this.onMiniaturize,
  }) : super(key: key);

  @override
  State<StepDots> createState() => _StepDotsState();
}

class _StepDotsState extends State<StepDots>
    with SingleTickerProviderStateMixin {
  late final ScrollController _scrollController;
  late final AnimationController _animationController;
  late final Animation<double> _offsetAnimation;
  late final Animation<double> _spacingAnimation;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
    _centerCurrentStepPostFrame();
  }

  void _initializeControllers() {
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _setupAnimations() {
    _offsetAnimation = Tween<double>(begin: 0.0, end: -4.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _spacingAnimation = Tween<double>(
      begin: 32.0, // Wide spacing
      end: 24.0, // Narrow spacing
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.value = _isEdgeStep ? 0.0 : 1.0;
  }

  void _centerCurrentStepPostFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerCurrentStep(animate: false);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StepDots oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentStep != oldWidget.currentStep) {
      _updateAnimationOnStepChange();
      _centerCurrentStep(animate: true);
    }
  }

  void _updateAnimationOnStepChange() {
    _isEdgeStep
        ? _animationController.reverse()
        : _animationController.forward();
  }

  void _centerCurrentStep({required bool animate}) {
    StepIndicatorsUtils.centerScrollToItem(
      scrollController: _scrollController,
      currentStep: widget.currentStep,
      totalSteps: widget.steps.length,
      itemWidth: _spacingAnimation.value,
      animate: animate,
    );
  }

  bool get _isEdgeStep =>
      widget.currentStep == 0 || widget.currentStep == widget.steps.length - 1;

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    if (_isEdgeStep && details.delta.dy > 0) {
      widget.onExpand();
    }
  }

  void _handleDotTap(int index) {
    if (index != 0 && index != widget.steps.length - 1) {
      widget.onMiniaturize();
    }
  }

  List<BoxShadow> _createDotShadows(Color color, bool isSelected) {
    if (!isSelected) {
      return [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 4,
          spreadRadius: 1,
        ),
      ];
    }

    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.25),
        blurRadius: 4,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: color.withOpacity(0.3),
        blurRadius: 8,
        spreadRadius: 2,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => _buildStepDotsContainer(),
    );
  }

  Widget _buildStepDotsContainer() {
    final itemWidth = _spacingAnimation.value;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      transform: Matrix4.translationValues(0, _offsetAnimation.value, 0),
      child: LayoutBuilder(
        builder: (context, constraints) => _buildScrollableStepDots(
          constraints.maxWidth,
          itemWidth,
        ),
      ),
    );
  }

  Widget _buildScrollableStepDots(double screenWidth, double itemWidth) {
    final totalContentWidth = widget.steps.length * itemWidth;
    final sidePadding =
        _calculateSidePadding(screenWidth, totalContentWidth, itemWidth);

    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: sidePadding),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _buildStepDotWidgets(itemWidth),
        ),
      ),
    );
  }

  double _calculateSidePadding(
      double screenWidth, double totalContentWidth, double itemWidth) {
    return totalContentWidth <= screenWidth
        ? (screenWidth - totalContentWidth) / 2
        : _isEdgeStep
            ? 128.0
            : 96.0;
  }

  List<Widget> _buildStepDotWidgets(double itemWidth) {
    return List.generate(
      widget.steps.length,
      (index) => _buildSingleStepDot(index, itemWidth),
    );
  }

  Widget _buildSingleStepDot(int index, double itemWidth) {
    final color = StepTypeUtils.getColorForStepType(widget.steps[index].type);
    final isCurrentStep = index == widget.currentStep;

    return GestureDetector(
      onTap: () => _handleDotTap(index),
      onVerticalDragUpdate: _isEdgeStep ? _handleVerticalDragUpdate : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: itemWidth,
        height: 24.0, // Reduced height to place dots higher
        alignment: Alignment.center,
        child: Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCurrentStep ? color : color.withOpacity(0.6),
            boxShadow: _createDotShadows(color, isCurrentStep),
            border: Border.all(
              color: color.withOpacity(0.8),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
