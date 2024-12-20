import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../../../core/utils/step_type_utils.dart';
import '../step_carousel.dart';
import '../common/shadowed_text.dart';
import '../rating_stars.dart';

// Using StepTypeUtils for visual elements

class PostStepContent extends StatelessWidget {
  final int index;
  final int totalSteps;
  final PostModel post;
  final String? currentUserId;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final Function(double) onRate;
  final BoxConstraints constraints;

  const PostStepContent({
    super.key,
    required this.index,
    required this.totalSteps,
    required this.post,
    required this.currentUserId,
    required this.onLike,
    required this.onShare,
    required this.onRate,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    if (index == 0) {
      return _buildIntroStep();
    } else if (index == totalSteps - 1) {
      return _buildOutroStep();
    } else {
      return _buildRegularStep();
    }
  }

  Widget _buildIntroStep() {
    final isLiked = currentUserId != null && post.likes.contains(currentUserId);
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShadowedText(
                  text: post.title,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ShadowedText(
                  text: post.description,
                  fontSize: 16,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 48,
          left: 0,
          right: 0,
          child: Center(
            child: IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.white,
                size: 32,
              ),
              onPressed: onLike,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutroStep() {
    final userRating = currentUserId != null
        ? post.getUserRating(currentUserId!)?.value ?? 0.0
        : 0.0;
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ShadowedText(
                      text: 'Rate this post',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 16),
                    RatingStars(
                      rating: userRating,
                      onRatingChanged: onRate,
                      isInteractive: true,
                      size: 32,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 24),
                    IconButton(
                      icon: const Icon(
                        Icons.share_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                      onPressed: onShare,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegularStep() {
    final step = post.steps[index - 1];
    final color = StepTypeUtils.getColorForStepType(step.type);
    final icon = StepTypeUtils.getIconForStepType(step.type);
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Stack(
        children: [
          StepCarousel(
            steps: [step],
            showArrows: false,
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Icon(icon, color: color, size: 24),
          ),
        ],
      ),
    );
  }
}
