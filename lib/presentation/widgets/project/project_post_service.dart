import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/post_model.dart';
import '../../../presentation/screens/feed/feed_bloc/feed_bloc.dart';
import '../../../presentation/screens/feed/feed_bloc/feed_event.dart';

class PostSelectionSheet extends StatelessWidget {
  final String projectId;
  final String projectName;
  final List<PostModel> availablePosts;

  const PostSelectionSheet({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.availablePosts,
  });

  static void show(BuildContext context, {
    required String projectId,
    required String projectName,
    required List<PostModel> availablePosts,
  }) {
    if (availablePosts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No available posts to add'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => PostSelectionSheet(
        projectId: projectId,
        projectName: projectName,
        availablePosts: availablePosts,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Post to $projectName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availablePosts.length,
              itemBuilder: (context, index) {
                final post = availablePosts[index];
                return ListTile(
                  title: Text(
                    post.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    post.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                    onPressed: () => _addPostToProject(context, post.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
