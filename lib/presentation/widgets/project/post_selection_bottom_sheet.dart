// DEPRECATED: This file is no longer in use. 
// The functionality has been moved to post_selection_sheet.dart which implements
// the new UI with compact post cards and multi-selection capability.
// Keeping this file for reference purposes only.

import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';

class PostSelectionSheet extends StatelessWidget {
  final String projectName;
  final List<PostModel> availablePosts;
  final Function(String) onPostSelected;

  const PostSelectionSheet({
    super.key,
    required this.projectName,
    required this.availablePosts,
    required this.onPostSelected,
  });

  static void show({
    required BuildContext context,
    required String projectName,
    required List<PostModel> availablePosts,
    required Function(String) onPostSelected,
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
        projectName: projectName,
        availablePosts: availablePosts,
        onPostSelected: onPostSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
                      onPressed: () {
                        onPostSelected(post.id);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
