import 'package:flutter/material.dart';
import '../../data/models/post_model.dart';
import '../../core/utils/step_type_utils.dart';
import 'rating_stars.dart';

class CompactPostCard extends StatefulWidget {
  final PostModel post;
  final double width;
  final double height;
  final bool circular;

  static const double _originalAvatarSize = 38.4;
  static const double _profileAvatarScale = 0.9;
  static const double _textScale = 0.6;
  static const double _titleScale = 0.7;
  static const double _miniatureScale = 0.5;

  const CompactPostCard({
    super.key,
    required this.post,
    this.width = 120,
    this.height = 120,
    this.circular = true,
  });

  @override
  State<CompactPostCard> createState() => _CompactPostCardState();
}

class _CompactPostCardState extends State<CompactPostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isExpanded = false;
  final ScrollController _scrollController = ScrollController();
  double _dragStartY = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _handleVerticalDragStart(DragStartDetails details) {
    _dragStartY = details.globalPosition.dy;
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    final deltaY = details.globalPosition.dy - _dragStartY;
    if (!_isExpanded && deltaY > 20) {
      _toggleExpanded();
    } else if (_isExpanded && deltaY < -20) {
      _toggleExpanded();
    }
  }

  Widget _buildStepMiniature(PostStep step, int index) {
    final color = StepTypeUtils.getColorForStepType(step.type);
    final icon = StepTypeUtils.getIconForStepType(step.type);
    final miniatureSize = widget.width * CompactPostCard._miniatureScale;

    return Container(
      width: miniatureSize,
      height: miniatureSize,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 4),
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

  Widget _buildExpandedContent(BuildContext context) {
    final miniatureSize = widget.width * CompactPostCard._miniatureScale;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Dark overlay
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.65),
          ),
        ),
        // Content
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Only show content when animation is more than 80% complete
            if (_controller.value < 0.8) return const SizedBox();

            return ClipOval(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: widget.height * 0.15),
                    child: RatingStars(
                      rating: widget.post.ratingStats.averageRating,
                      size: 20,
                      color: Colors.amber,
                      distribution: widget.post.ratingStats.ratingDistribution,
                      totalRatings: widget.post.ratings.length,
                      showRatingText: true,
                    ),
                  ),
                  if (widget.post.steps.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: widget.height * 0.15),
                      child: SizedBox(
                        height: miniatureSize,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: widget.post.steps.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) => _buildStepMiniature(
                            widget.post.steps[index],
                            index,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCollapsedContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.post.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24 * CompactPostCard._titleScale,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.post.description,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16 * CompactPostCard._textScale,
              ),
            ),
          ],
        ),
      ),
    );
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
          onVerticalDragStart: _handleVerticalDragStart,
          onVerticalDragUpdate: _handleVerticalDragUpdate,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.6),
            ),
            child: ClipOval(
              child: Stack(
                children: [
                  // Base layer with profile image
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final expandedSize = widget.width;
                      final size = Tween<double>(
                        begin: CompactPostCard._originalAvatarSize *
                            CompactPostCard._profileAvatarScale,
                        end: expandedSize,
                      ).evaluate(_controller);

                      final top = Tween<double>(
                        begin: 8,
                        end: 0,
                      ).evaluate(_controller);

                      return Positioned(
                        top: top,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: _toggleExpanded,
                            child: Container(
                              width: size,
                              height: size,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  widget.post.userProfileImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Colors.black,
                                    child: Center(
                                      child: Text(
                                        widget.post.username[0].toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              16 * CompactPostCard._textScale,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Content layer
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return _isExpanded
                          ? Positioned.fill(
                              child: Opacity(
                                opacity: _controller.value,
                                child: _buildExpandedContent(context),
                              ),
                            )
                          : Positioned.fill(
                              child: Opacity(
                                opacity: 1 - _controller.value,
                                child: _buildCollapsedContent(),
                              ),
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
