import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../../../core/utils/step_type_utils.dart';
import '../constants/post_widget_constants.dart';
import '../rating_stars.dart';
import '../step_indicators/step_miniatures.dart';

class ExpandablePostContent extends StatefulWidget {
  final bool isExpanded;
  final Animation<double> animation;
  final ScrollController scrollController;
  final PostModel? post;
  final String title;
  final String description;
  final double rating;
  final int? totalRatings;
  final List<PostStep>? steps;
  final bool showHeartButton;
  final VoidCallback? onUnsave;
  final double width;

  const ExpandablePostContent({
    super.key,
    required this.isExpanded,
    required this.animation,
    required this.scrollController,
    this.post,
    required this.title,
    required this.description,
    required this.rating,
    this.totalRatings,
    this.steps,
    this.showHeartButton = false,
    this.onUnsave,
    required this.width,
  });

  @override
  State<ExpandablePostContent> createState() => _ExpandablePostContentState();
}

class _ExpandablePostContentState extends State<ExpandablePostContent> {
  late final PageController _pageController;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_handlePageChange);
  }

  @override
  void dispose() {
    _pageController.removeListener(_handlePageChange);
    _pageController.dispose();
    super.dispose();
  }

  void _handlePageChange() {
    if (_pageController.page != null && _pageController.page!.round() != _currentStep) {
      setState(() {
        _currentStep = _pageController.page!.round();
      });
    }
  }

  Widget _buildHeartButton() {
    return GestureDetector(
      onTap: widget.onUnsave,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[300]!,
              Colors.grey[400]!,
              Colors.grey[500]!,
            ],
          ).createShader(bounds);
        },
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.favorite,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    final ratingSize = PostWidgetConstants.starSize * 0.7;
    final starsWidth = widget.width * 0.4;

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.65),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: constraints.maxHeight * 0.15),
                if (widget.totalRatings != null)
                  Text(
                    '${widget.totalRatings} ratings',
                    style: const TextStyle(
                      color: Colors.amber,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 4),
                Center(
                  child: SizedBox(
                    width: starsWidth,
                    child: RatingStars(
                      rating: widget.rating,
                      size: ratingSize,
                      color: Colors.amber,
                      frameWidth: starsWidth,
                      sizeModifier: 0,
                      starSpacing: 1.0,
                      curvature: 0.15,
                      isInteractive: false,
                    ),
                  ),
                ),
                const Spacer(),
                if (widget.steps != null && widget.steps!.isNotEmpty)
                  SizedBox(
                    height: 72,
                    child: StepMiniatures(
                      steps: widget.steps!,
                      currentStep: _currentStep,
                      onExpand: () {},
                      pageController: _pageController,
                      showSelection: false, // Disable selection effects for compact post
                      centerBetweenFirstTwo: true, // Center between first two miniatures
                    ),
                  ),
                SizedBox(height: constraints.maxHeight * 0.1),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCollapsedContent() {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24 * PostWidgetConstants.titleScale,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16 * PostWidgetConstants.textScale,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.showHeartButton)
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Center(
              child: _buildHeartButton(),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        return widget.isExpanded
            ? Positioned.fill(
                child: Opacity(
                  opacity: widget.animation.value,
                  child: _buildExpandedContent(),
                ),
              )
            : Positioned.fill(
                child: Opacity(
                  opacity: 1 - widget.animation.value,
                  child: _buildCollapsedContent(),
                ),
              );
      },
    );
  }
}
