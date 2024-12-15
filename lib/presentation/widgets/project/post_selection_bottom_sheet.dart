import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/post_model.dart';
import '../../../presentation/screens/feed/feed_bloc/feed_bloc.dart';
import '../../../presentation/screens/feed/feed_bloc/feed_event.dart';
import '../../../presentation/screens/feed/feed_bloc/feed_state.dart';

class PostSelectionBottomSheet extends StatelessWidget {
  final String projectId;
  final String projectName;
  final List<String> existingPostIds;

  const PostSelectionBottomSheet({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.existingPostIds,
  });

  static void show(BuildContext context, {
    required String projectId,
    required String projectName,
    required List<String> existingPostIds,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => PostSelectionBottomSheet(
        projectId: projectId,
        projectName: projectName,
        existingPostIds: existingPostIds,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(
      builder: (context, state) {
        if (state is! FeedSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to add posts at this time'),
              backgroundColor: Colors.red,
            ),
          );
          return const SizedBox.shrink();
        }

        final availablePosts = state.posts.where(
          (post) => !existingPostIds.contains(post.id)
        ).toList();

        if (availablePosts.isEmpty) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No available posts to add'),
              backgroundColor: Colors.orange,
            ),
          );
          return const SizedBox.shrink();
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Select a post to add to this project:',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ),
                _buildPostList(context, availablePosts),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'Add Post to $projectName',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPostList(BuildContext context, List<PostModel> posts) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: posts.length,
        itemBuilder: (context, index) => _buildPostItem(context, posts[index]),
      ),
    );
  }

  Widget _buildPostItem(BuildContext context, PostModel post) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        title: Text(
          post.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              post.description,
              style: TextStyle(color: Colors.white.withOpacity(0.7)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _addPostToProject(context, post.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text('Add to Project'),
            ),
          ],
        ),
      ),
    );
  }

  void _addPostToProject(BuildContext context, String postId) {
    context.read<FeedBloc>().add(
      FeedAddPostToProject(
        projectId: projectId,
        postId: postId,
      ),
    );
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Post added to $projectName'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
