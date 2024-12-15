import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/post_model.dart';
import '../../../presentation/screens/feed/feed_bloc/feed_bloc.dart';
import '../../../presentation/screens/feed/feed_bloc/feed_event.dart';
import 'selectable_compact_post_card.dart';

class PostSelectionSheet extends StatefulWidget {
  final String projectId;
  final String projectName;
  final List<PostModel> availablePosts;

  const PostSelectionSheet({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.availablePosts,
  });

  static void show(
    BuildContext context, {
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
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      builder: (context) => PostSelectionSheet(
        projectId: projectId,
        projectName: projectName,
        availablePosts: availablePosts,
      ),
    );
  }

  @override
  State<PostSelectionSheet> createState() => _PostSelectionSheetState();
}

class _PostSelectionSheetState extends State<PostSelectionSheet> {
  final Set<String> _selectedPostIds = {};

  void _togglePostSelection(String postId) {
    setState(() {
      if (_selectedPostIds.contains(postId)) {
        _selectedPostIds.remove(postId);
      } else {
        _selectedPostIds.add(postId);
      }
    });
  }

  void _confirmSelection() {
    if (_selectedPostIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one post'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    for (final postId in _selectedPostIds) {
      context.read<FeedBloc>().add(
            FeedAddPostToProject(
              projectId: widget.projectId,
              postId: postId,
            ),
          );
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${_selectedPostIds.length} posts added to ${widget.projectName}'),
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
                  'Add Posts to ${widget.projectName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline,
                          color: Colors.white),
                      onPressed: _confirmSelection,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Flexible(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: widget.availablePosts.length,
              itemBuilder: (context, index) {
                final post = widget.availablePosts[index];
                return SelectableCompactPostCard(
                  post: post,
                  isSelected: _selectedPostIds.contains(post.id),
                  onToggle: () => _togglePostSelection(post.id),
                  isProjectPost: false, // These are available posts
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
