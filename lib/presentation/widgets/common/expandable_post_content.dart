import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../../../core/utils/step_type_utils.dart';
import '../constants/post_widget_constants.dart';
import '../rating_stars.dart';

class ExpandablePostContent extends StatelessWidget {
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

  Widget _buildHeartButton() {
    return GestureDetector(
      onTap: onUnsave,
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

  Widget _buildStepMiniature(PostStep step, int index) {
    final color = StepTypeUtils.getColorForStepType(step.type);
    final icon = StepTypeUtils.getIconForStepType(step.type);
    final miniatureSize =
        width * PostWidgetConstants.miniatureScale * 0.8; // Reduced size

    return Container(
      width: miniatureSize,
      height: miniatureSize,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: miniatureSize * 0.9,
        height: miniatureSize * 0.9,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.1),
          border: Border.all(
            color: color,
            width: 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: miniatureSize * 0.25,
              ),
              const SizedBox(height: 2),
              Text(
                '${index + 1}',
                style: TextStyle(
                  color: color,
                  fontSize: miniatureSize * 0.15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    final miniatureSize = width * PostWidgetConstants.miniatureScale * 0.8;
    final ratingSize = PostWidgetConstants.starSize * 0.7;
    final starsWidth = width * 0.4;

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
                if (totalRatings != null)
                  Text(
                    '$totalRatings ratings',
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
                      rating: rating,
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
                if (steps != null && steps!.isNotEmpty)
                  SizedBox(
                    height: miniatureSize,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: steps!.length,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      itemBuilder: (context, index) => _buildStepMiniature(
                        steps![index],
                        index,
                      ),
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
                  title,
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
                  description,
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
        if (showHeartButton)
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
      animation: animation,
      builder: (context, child) {
        return isExpanded
            ? Positioned.fill(
                child: Opacity(
                  opacity: animation.value,
                  child: _buildExpandedContent(),
                ),
              )
            : Positioned.fill(
                child: Opacity(
                  opacity: 1 - animation.value,
                  child: _buildCollapsedContent(),
                ),
              );
      },
    );
  }
}
