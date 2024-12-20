import 'package:flutter/material.dart';
import '../../../../data/models/post_model.dart';
import '../../../../data/models/project_model.dart';
import '../../../widgets/post_creation/in_feed_post_creation.dart';
import '../services/feed_item_service.dart';
import '../controllers/feed_controller.dart';
import 'feed_item.dart';

class FeedContent extends StatelessWidget {
  final ScrollController scrollController;
  final List<PostModel> posts;
  final List<ProjectModel> projects;
  final String currentUserId;
  final bool isCreatingPost;
  final GlobalKey<InFeedPostCreationState> postCreationKey;
  final VoidCallback onCancel;
  final Function(bool) onComplete;
  final double topPadding;
  final FeedController feedController;
  final GlobalKey? selectedItemKey;
  final String? selectedPostId;
  final String? selectedProjectId;

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
    required this.feedController,
    this.selectedItemKey,
    this.selectedPostId,
    this.selectedProjectId,
  });

  @override
  Widget build(BuildContext context) {
    // Only update item service if data has changed
    final currentService = feedController.itemService;
    if (currentService.posts != posts || 
        currentService.projects != projects || 
        currentService.isCreatingPost != isCreatingPost) {
      feedController.updateItemService(
        FeedItemService(
          posts: posts,
          projects: projects,
          isCreatingPost: isCreatingPost,
        )
      );
    }

    final itemService = feedController.itemService;

    if (posts.isEmpty && projects.isEmpty && !isCreatingPost) {
      return _buildEmptyState(context);
    }

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(top: topPadding),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Show post creation widget at the very top if active
                if (itemService.isCreatingPostPosition(index)) {
                  return FeedItem(
                    isCreatingPost: true,
                    postCreationKey: postCreationKey,
                    onCancel: onCancel,
                    onComplete: onComplete,
                    feedController: feedController,
                  );
                }

                // Adjust index for post creation widget
                final adjustedIndex = isCreatingPost ? index - 1 : index;

                // Check if this position should show a project
                final project = itemService.getProjectAtPosition(adjustedIndex);
                if (project != null) {
                  final isSelected = project.id == selectedProjectId;
                  // Only use selectedItemKey if the project matches the selected project ID
                  final key = isSelected && selectedItemKey != null 
                      ? selectedItemKey 
                      : ValueKey(project.id);
                  return FeedItem(
                    key: key,
                    project: project,
                    feedController: feedController,
                    isSelected: isSelected,
                  );
                }

                // Get post for this position
                final post = itemService.getPostAtPosition(adjustedIndex);
                if (post != null) {
                  final isSelected = post.id == selectedPostId;
                  // Only use selectedItemKey if the post matches the selected post ID
                  final key = isSelected && selectedItemKey != null 
                      ? selectedItemKey 
                      : ValueKey(post.id);
                  return FeedItem(
                    key: key,
                    post: post,
                    currentUserId: currentUserId,
                    feedController: feedController,
                    isSelected: isSelected,
                  );
                }

                // Show loading indicator at the end
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                );
              },
              childCount: itemService.totalItemCount,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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
}
