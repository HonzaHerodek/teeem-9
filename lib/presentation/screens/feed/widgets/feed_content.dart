import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/post_model.dart';
import '../../../../data/models/project_model.dart';
import '../../../widgets/post_card.dart';
import '../../../widgets/project_card.dart';
import '../../../widgets/post_creation/in_feed_post_creation.dart';
import '../feed_bloc/feed_bloc.dart';
import '../feed_bloc/feed_event.dart';

class FeedContent extends StatefulWidget {
  final ScrollController scrollController;
  final List<PostModel> posts;
  final List<ProjectModel> projects;
  final String currentUserId;
  final bool isCreatingPost;
  final GlobalKey<InFeedPostCreationState> postCreationKey;
  final VoidCallback onCancel;
  final Function(bool) onComplete;
  final double topPadding;

  const FeedContent({
    super.key,
    required this.scrollController,
    required this.posts,
    required this.projects,
    required this.currentUserId,
    required this.isCreatingPost,
    required this.postCreationKey,
    required this.onCancel,
    required this.onComplete,
    required this.topPadding,
  });

  @override
  State<FeedContent> createState() => _FeedContentState();
}

class _FeedContentState extends State<FeedContent> {
  bool _isScrolling = false;
  double _startScrollPosition = 0;

  int get _totalItemCount {
    int count = widget.posts.length;
    if (widget.projects.isNotEmpty) {
      count += 1;
      count += ((widget.posts.length - 1) / 5).floor();
    }
    if (widget.isCreatingPost) {
      count += 1;
    }
    return count;
  }

  void _handleScrollStart(DragStartDetails details) {
    _isScrolling = true;
    _startScrollPosition = widget.scrollController.position.pixels;
  }

  void _handleScrollUpdate(DragUpdateDetails details) {
    if (!_isScrolling) return;
    
    final delta = details.primaryDelta ?? 0;
    widget.scrollController.jumpTo(widget.scrollController.position.pixels - delta);
  }

  void _handleScrollEnd(DragEndDetails details) {
    if (!_isScrolling) return;
    _isScrolling = false;

    final velocity = details.primaryVelocity ?? 0;
    if (velocity.abs() > 0) {
      widget.scrollController.animateTo(
        widget.scrollController.position.pixels - velocity * 0.2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.post_add,
            size: 64,
            color: Colors.white70,
          ),
          const SizedBox(height: 16),
          Text(
            'No content yet',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to create a post!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.posts.isEmpty && widget.projects.isEmpty && !widget.isCreatingPost) {
      return _buildEmptyState();
    }

    return GestureDetector(
      onVerticalDragStart: _handleScrollStart,
      onVerticalDragUpdate: _handleScrollUpdate,
      onVerticalDragEnd: _handleScrollEnd,
      behavior: HitTestBehavior.translucent,
      child: CustomScrollView(
        controller: widget.scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(top: widget.topPadding),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (widget.isCreatingPost && index == 0) {
                    return InFeedPostCreation(
                      key: widget.postCreationKey,
                      onCancel: widget.onCancel,
                      onComplete: widget.onComplete,
                    );
                  }

                  final adjustedIndex = widget.isCreatingPost ? index - 1 : index;

                  if (widget.projects.isNotEmpty && adjustedIndex == 0) {
                    return ProjectCard(
                      project: widget.projects[0],
                      onTap: () {
                        context.read<FeedBloc>().add(
                          FeedProjectSelected(widget.projects[0].id),
                        );
                      },
                    );
                  }

                  final isProjectPosition = widget.projects.length > 1 && 
                                       adjustedIndex > 1 && 
                                       ((adjustedIndex - 1) % 6 == 5);

                  if (isProjectPosition) {
                    final projectIndex = (((adjustedIndex - 1) - 5) ~/ 6 + 1) % widget.projects.length;
                    return ProjectCard(
                      project: widget.projects[projectIndex],
                      onTap: () {
                        context.read<FeedBloc>().add(
                          FeedProjectSelected(widget.projects[projectIndex].id),
                        );
                      },
                    );
                  }

                  final postIndex = adjustedIndex - 1 - ((adjustedIndex - 1) ~/ 6);
                  
                  if (postIndex >= widget.posts.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    );
                  }

                  final post = widget.posts[postIndex];
                  return PostCard(
                    post: post,
                    currentUserId: widget.currentUserId,
                    onLike: () {
                      context.read<FeedBloc>().add(FeedPostLiked(post.id));
                    },
                    onComment: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Comments coming soon!')),
                      );
                    },
                    onShare: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Share feature coming soon!')),
                      );
                    },
                    onRate: (rating) {
                      context.read<FeedBloc>().add(FeedPostRated(post.id, rating));
                    },
                  );
                },
                childCount: _totalItemCount,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
