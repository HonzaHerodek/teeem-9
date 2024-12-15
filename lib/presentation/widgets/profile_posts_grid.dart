import 'package:flutter/material.dart';
import '../../data/models/post_model.dart';
import '../../core/utils/step_type_utils.dart';
import 'rating_stars.dart';

class PostRowHeader extends StatelessWidget {
  final String title;
  final IconData? backgroundIcon;

  const PostRowHeader({
    super.key,
    required this.title,
    this.backgroundIcon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (backgroundIcon != null)
            Positioned(
              left: screenWidth / 2 - 45, // Center horizontally
              top: -10,
              child: Container(
                width: 90,
                height: 90,
                child: Icon(
                  backgroundIcon!,
                  size: 80,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w100,
              letterSpacing: 1.2,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePostCard extends StatefulWidget {
  final PostModel post;
  static const double _originalAvatarSize = 38.4;
  static const double _profileAvatarScale = 0.9;
  static const double _textScale = 0.6;
  static const double _titleScale = 0.7;

  const ProfilePostCard({
    super.key,
    required this.post,
  });

  @override
  State<ProfilePostCard> createState() => _ProfilePostCardState();
}

class _ProfilePostCardState extends State<ProfilePostCard>
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

    return Container(
      width: 34.0,
      height: 34.0,
      alignment: Alignment.center,
      child: Container(
        width: 30.0,
        height: 30.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.3),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color.withOpacity(0.7),
                size: 10,
              ),
              const SizedBox(height: 1),
              Text(
                '${index + 1}',
                style: TextStyle(
                  color: color.withOpacity(0.7),
                  fontSize: 6,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 32),
        RatingStars(
          rating: widget.post.ratingStats.averageRating,
          size: 24,
          color: Colors.amber,
          distribution: widget.post.ratingStats.ratingDistribution,
          totalRatings: widget.post.ratings.length,
          showRatingText: true,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 34.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.post.steps.length,
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.5),
            itemBuilder: (context, index) => _buildStepMiniature(
              widget.post.steps[index],
              index,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: GestureDetector(
        onVerticalDragStart: _handleVerticalDragStart,
        onVerticalDragUpdate: _handleVerticalDragUpdate,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.6),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[850]!.withOpacity(0.5),
                blurRadius: 35,
                spreadRadius: 8,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: ClipOval(
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final expandedSize =
                        MediaQuery.of(context).size.width * 0.4;
                    final size = Tween<double>(
                      begin: ProfilePostCard._originalAvatarSize *
                          ProfilePostCard._profileAvatarScale,
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
                          child: Stack(
                            children: [
                              Container(
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
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      color: Colors.black,
                                      child: Center(
                                        child: Text(
                                          widget.post.username[0].toUpperCase(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                16 * ProfilePostCard._textScale,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (_isExpanded)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        widget.post.title,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: true,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              24 * ProfilePostCard._titleScale,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        widget.post.description,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              16 * ProfilePostCard._textScale,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePostsGrid extends StatelessWidget {
  final List<PostModel> posts;
  final String currentUserId;
  final Function(PostModel) onLike;
  final Function(PostModel) onComment;
  final Function(PostModel) onShare;
  final Function(double, PostModel) onRate;

  const ProfilePostsGrid({
    super.key,
    required this.posts,
    required this.currentUserId,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onRate,
  });

  Widget _buildPostRow(
    BuildContext context, {
    required String title,
    required List<PostModel> posts,
    IconData? backgroundIcon,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final postSize = screenWidth * 0.4;
    final rowHeight = postSize + 16;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostRowHeader(
          title: title,
          backgroundIcon: backgroundIcon,
        ),
        SizedBox(
          height: rowHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Container(
                width: postSize,
                height: postSize,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: ProfilePostCard(
                  post: post,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: These lists should come from actual filtered data
    final likedPosts = posts.take(3).toList();
    final createdPosts = posts.skip(1).take(3).toList();
    final respondedPosts = posts.skip(2).take(3).toList();
    final unfinishedPosts = posts.skip(3).take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPostRow(
          context,
          title: 'Saved',
          posts: likedPosts,
          backgroundIcon: Icons.favorite_rounded,
        ),
        const SizedBox(height: 24),
        _buildPostRow(
          context,
          title: 'Created',
          posts: createdPosts,
          backgroundIcon: Icons.create_rounded,
        ),
        const SizedBox(height: 24),
        _buildPostRow(
          context,
          title: 'Responded',
          posts: respondedPosts,
          backgroundIcon: Icons.reply_rounded,
        ),
        const SizedBox(height: 24),
        _buildPostRow(
          context,
          title: 'Unfinished',
          posts: unfinishedPosts,
          backgroundIcon: Icons.pending_rounded,
        ),
      ],
    );
  }
}
