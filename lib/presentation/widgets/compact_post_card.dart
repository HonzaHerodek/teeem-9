import 'package:flutter/material.dart';
import '../../data/models/post_model.dart';
import 'common/animated_profile_picture.dart';
import 'common/expandable_post_content.dart';
import 'mixins/expandable_content_mixin.dart';
import 'mixins/scale_animation_mixin.dart';
import 'constants/post_widget_constants.dart';

class CompactPostCard extends StatefulWidget {
  final PostModel post;
  final double width;
  final double height;
  final bool circular;
  final bool showHeartButton;
  final VoidCallback? onUnsave;

  const CompactPostCard({
    super.key,
    required this.post,
    this.width = 120,
    this.height = 120,
    this.circular = true,
    this.showHeartButton = false,
    this.onUnsave,
  });

  @override
  State<CompactPostCard> createState() => _CompactPostCardState();
}

class _CompactPostCardState extends State<CompactPostCard>
    with TickerProviderStateMixin, ExpandableContentMixin, ScaleAnimationMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isProfileTapArea = false;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();
    initializeExpandableContent();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _tapPosition = details.globalPosition;
    // Check if tap is in profile area (top 40% of the card)
    _isProfileTapArea = details.localPosition.dy < widget.height * 0.4;
    
    // If not in profile area, trigger scale animation
    if (!_isProfileTapArea) {
      scaleUp();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    // Only handle tap if the finger hasn't moved significantly
    if (_tapPosition != null &&
        (details.globalPosition - _tapPosition!).distance < 10) {
      if (_isProfileTapArea) {
        if (isExpanded) {
          // Close profile view
          setState(() => updateExpandedState(false));
        } else {
          // Expand profile view
          setState(() => updateExpandedState(true));
        }
      } else {
        // Scale down after a short delay
        Future.delayed(const Duration(milliseconds: 150), scaleDown);
      }
    } else {
      // If finger has moved, just reset scale
      scaleDown();
    }
    _tapPosition = null;
  }

  void _handleTapCancel() {
    _tapPosition = null;
    if (!_isProfileTapArea) {
      scaleDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: PhysicalModel(
        color: Colors.transparent,
        shadowColor: Colors.grey[850]!,
        elevation: 25,
        shape: BoxShape.circle,
        clipBehavior: Clip.none,
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onVerticalDragStart: handleVerticalDragStart,
          onVerticalDragUpdate: (details) => handleVerticalDragUpdate(
            details,
            onExpand: () => setState(() => updateExpandedState(true)),
            onCollapse: () => setState(() => updateExpandedState(false)),
          ),
          onVerticalDragEnd: handleVerticalDragEnd,
          behavior: HitTestBehavior.translucent,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.6),
              ),
              child: ClipOval(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AnimatedProfilePicture(
                      imageUrl: widget.post.userProfileImage,
                      username: widget.post.username,
                      headerHeight: widget.height,
                      postSize: widget.width,
                      animation: controller,
                      isExpanded: isExpanded,
                      onTap: null, // Handled by parent gesture detector
                      showFullScreenWhenExpanded: false,
                    ),
                    AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return Stack(
                          children: [
                            // Non-expanded content (title, description)
                            Opacity(
                              opacity: 1.0 - controller.value,
                              child: ExpandablePostContent(
                                isExpanded: false,
                                animation: controller,
                                scrollController: _scrollController,
                                title: widget.post.title,
                                description: widget.post.description,
                                rating: widget.post.ratingStats.averageRating,
                                totalRatings: widget.post.ratings.length,
                                steps: widget.post.steps,
                                showHeartButton: widget.showHeartButton,
                                onUnsave: widget.onUnsave,
                                width: widget.width,
                              ),
                            ),
                            // Expanded content
                            Opacity(
                              opacity: controller.value,
                              child: ExpandablePostContent(
                                isExpanded: true,
                                animation: controller,
                                scrollController: _scrollController,
                                post: widget.post,
                                title: widget.post.title,
                                description: widget.post.description,
                                rating: widget.post.ratingStats.averageRating,
                                totalRatings: widget.post.ratings.length,
                                steps: widget.post.steps,
                                showHeartButton: widget.showHeartButton,
                                onUnsave: widget.onUnsave,
                                width: widget.width,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
