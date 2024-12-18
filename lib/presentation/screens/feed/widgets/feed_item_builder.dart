import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/models/post_model.dart';
import '../../../../data/models/project_model.dart';
import '../../../widgets/post_card.dart';
import '../../../widgets/project_card.dart';
import '../../../widgets/post_creation/in_feed_post_creation.dart';
import '../feed_bloc/feed_bloc.dart';
import '../feed_bloc/feed_event.dart';

class FeedItemBuilder {
  final List<PostModel> posts;
  final List<ProjectModel> projects;
  final String currentUserId;
  final bool isCreatingPost;
  final GlobalKey<InFeedPostCreationState> postCreationKey;
  final VoidCallback onCancel;
  final Function(bool) onComplete;

  const FeedItemBuilder({
    required this.posts,
    required this.projects,
    required this.currentUserId,
    required this.isCreatingPost,
    required this.postCreationKey,
    required this.onCancel,
    required this.onComplete,
  });

  Widget buildItem(BuildContext context, int index) {
    // Show post creation widget at the very top if active
    if (isCreatingPost && index == 0) {
      return InFeedPostCreation(
        key: postCreationKey,
        onCancel: onCancel,
        onComplete: onComplete,
      );
    }

    // Adjust index for post creation widget
    final adjustedIndex = isCreatingPost ? index - 1 : index;

    // Show first project at index 0 (after post creation if active)
    if (projects.isNotEmpty && adjustedIndex == 0) {
      return ProjectCard(
        project: projects[0],
        onTap: () {
          context.read<FeedBloc>().add(
            FeedProjectSelected(projects[0].id),
          );
        },
      );
    }

    // Calculate if this position should show another project
    final isProjectPosition = projects.length > 1 && 
                           adjustedIndex > 1 && 
                           ((adjustedIndex - 1) % 6 == 5);

    if (isProjectPosition) {
      final projectIndex = (((adjustedIndex - 1) - 5) ~/ 6 + 1) % projects.length;
      return ProjectCard(
        project: projects[projectIndex],
        onTap: () {
          context.read<FeedBloc>().add(
            FeedProjectSelected(projects[projectIndex].id),
          );
        },
      );
    }

    // Calculate actual post index accounting for project cards
    final postIndex = adjustedIndex - 1 - ((adjustedIndex - 1) ~/ 6);
    
    if (postIndex >= posts.length) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    final post = posts[postIndex];
    return PostCard(
      post: post,
      currentUserId: currentUserId,
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
  }

  int get totalItemCount {
    int count = posts.length;
    if (projects.isNotEmpty) {
      count += 1;
      count += ((posts.length - 1) / 5).floor();
    }
    if (isCreatingPost) {
      count += 1;
    }
    return count;
  }
}
