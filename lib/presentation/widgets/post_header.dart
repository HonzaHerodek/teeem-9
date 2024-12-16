import 'package:flutter/material.dart';
import '../../data/models/post_model.dart';
import '../../data/models/trait_model.dart';
import '../../domain/repositories/post_repository.dart';
import '../../core/di/injection.dart';
import 'common/animated_profile_picture.dart';
import 'common/other_posts_list.dart';
import 'mixins/expandable_content_mixin.dart';
import 'constants/post_widget_constants.dart';
import 'rating_stars.dart';
import 'rating_count_star.dart';
import 'user_traits.dart';

class PostHeader extends StatefulWidget {
  final String username;
  final String? userProfileImage;
  final List<PostStep> steps;
  final int currentStep;
  final bool isExpanded;
  final Function(bool) onExpandChanged;
  final String userId;
  final String currentPostId;
  final Function(double)? onAnimationChanged;
  final List<TraitModel> userTraits;
  final double rating;

  const PostHeader({
    super.key,
    required this.username,
    this.userProfileImage,
    required this.steps,
    required this.currentStep,
    required this.isExpanded,
    required this.onExpandChanged,
    required this.userId,
    required this.currentPostId,
    this.onAnimationChanged,
    this.userTraits = const [],
    required this.rating,
  });

  @override
  State<PostHeader> createState() => _PostHeaderState();
}

class _PostHeaderState extends State<PostHeader>
    with TickerProviderStateMixin, ExpandableContentMixin {
  List<PostModel>? _otherPosts;
  bool _isLoadingPosts = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    initializeExpandableContent(
      startExpanded: widget.isExpanded,
      onAnimationChanged: widget.onAnimationChanged,
    );

    if (widget.isExpanded) {
      _fetchOtherPosts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PostHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isExpanded != widget.isExpanded) {
      if (widget.isExpanded) {
        controller.forward();
        _fetchOtherPosts();
      } else {
        controller.reverse();
      }
    }
  }

  Future<void> _fetchOtherPosts() async {
    if (_isLoadingPosts) return;

    setState(() {
      _isLoadingPosts = true;
    });

    try {
      final posts = await getIt<PostRepository>().getPosts(
        userId: widget.userId,
        limit: 10,
      );

      if (mounted) {
        setState(() {
          _otherPosts =
              posts.where((post) => post.id != widget.currentPostId).toList();
          _isLoadingPosts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingPosts = false;
        });
      }
    }
  }

  bool get _showProfilePicture =>
      widget.currentStep == 0 || widget.currentStep == widget.steps.length - 1;

  bool get _canExpand =>
      widget.currentStep == 0 || widget.currentStep == widget.steps.length - 1;

  Widget _buildHeaderContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final starsWidth = screenWidth * 0.6; // 60% of screen width

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_otherPosts != null) ...[
          // Rating count star above stars
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RatingCountStar(
                  count: _otherPosts!.fold<int>(
                    0,
                    (sum, post) => sum + post.ratings.length,
                  ),
                  size: 24,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: starsWidth,
                  child: RatingStars(
                    rating: widget.rating,
                    size: 24,
                    color: Colors.amber,
                    frameWidth: starsWidth,
                    sizeModifier: 0.2, // This maps to starSizeIncrease of 1.2
                    starSpacing: 3.6,
                    curvature: 0.3,
                    isInteractive: false,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        if (widget.userTraits.isNotEmpty)
          UserTraits(
            traits: widget.userTraits,
            height: 40,
            itemWidth: 100,
            itemHeight: 40,
            spacing: 8,
          ),
        const SizedBox(height: 16),
        if (_otherPosts != null && _otherPosts!.isNotEmpty)
          OtherPostsList(
            posts: _otherPosts!,
            scrollController: _scrollController,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final postSize = MediaQuery.of(context).size.width - 32;
    final expandedHeight = postSize * 0.75;
    final headerHeight = widget.isExpanded ? expandedHeight : 120.0;

    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.none,
      child: Container(
        width: double.infinity,
        height: headerHeight,
        clipBehavior: Clip.none,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: PostWidgetConstants.animationDuration,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.vertical(
                  top: const Radius.circular(999),
                  bottom: Radius.circular(widget.isExpanded ? postSize / 2 : 0),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: controller,
              builder: (context, child) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: const Radius.circular(999),
                        bottom: Radius.circular(
                            widget.isExpanded ? postSize / 2 : 0),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7 * controller.value),
                          Colors.black.withOpacity(0.5 * controller.value),
                          Colors.black.withOpacity(0.7 * controller.value),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            if (_showProfilePicture)
              AnimatedProfilePicture(
                imageUrl: widget.userProfileImage,
                username: widget.username,
                headerHeight: headerHeight,
                postSize: postSize,
                animation: controller,
                isExpanded: widget.isExpanded,
                onTap: _canExpand ? () => widget.onExpandChanged(true) : null,
                canExpand: _canExpand,
                showFullScreenWhenExpanded: true,
              ),
            if (widget.isExpanded) ...[
              Positioned(
                top: 32,
                left: 0,
                right: 0,
                child: _buildHeaderContent(),
              ),
              if (_isLoadingPosts)
                const Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
            ],
            if (widget.isExpanded)
              Positioned.fill(
                child: GestureDetector(
                  onVerticalDragStart: handleVerticalDragStart,
                  onVerticalDragUpdate: (details) => handleVerticalDragUpdate(
                    details,
                    onExpand: () {},
                    onCollapse: () => widget.onExpandChanged(false),
                  ),
                ),
              ),
            if (!widget.isExpanded && _canExpand)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 120,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapDown: (_) => widget.onExpandChanged(true),
                  onVerticalDragStart: handleVerticalDragStart,
                  onVerticalDragUpdate: (details) => handleVerticalDragUpdate(
                    details,
                    onExpand: () => widget.onExpandChanged(true),
                    onCollapse: () {},
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
