import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../compact_post_card.dart';
import 'selectable_compact_post_card.dart';
import 'project_post_selection_service.dart';

class ProjectPostList extends StatelessWidget {
  final List<PostModel> posts;
  final bool isSelectable;
  final ProjectPostSelectionService service;
  final bool isProjectPosts;
  final String title;
  static const double _postSize = 140.0;
  static const Duration _animationDuration = Duration(milliseconds: 300);
  static const Curve _animationCurve = Curves.easeInOut;

  const ProjectPostList({
    super.key,
    required this.posts,
    required this.isSelectable,
    required this.service,
    required this.isProjectPosts,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    if (posts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        const SizedBox(height: 8),
        AnimatedOpacity(
          duration: _animationDuration,
          curve: _animationCurve,
          opacity: 1.0,
          child: SizedBox(
            height: _postSize,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: posts.length,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemBuilder: (context, index) {
                final post = posts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: isSelectable
                      ? SelectableCompactPostCard(
                          post: post,
                          width: _postSize,
                          height: _postSize,
                          isSelected: service.selectedPostIds.contains(post.id),
                          onToggle: () => service.togglePostSelection(post.id),
                          isProjectPost: isProjectPosts,
                        )
                      : CompactPostCard(
                          post: post,
                          width: _postSize,
                          height: _postSize,
                          circular: true,
                        ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
