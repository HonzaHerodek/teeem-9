import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../compact_post_card.dart';

class ProjectContent extends StatelessWidget {
  final String name;
  final String description;
  final List<PostModel> posts;
  final bool isLoading;
  final String errorMessage;

  const ProjectContent({
    super.key,
    required this.name,
    required this.description,
    required this.posts,
    required this.isLoading,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12.0),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _buildContent(context),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Text(
          errorMessage,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
        ),
      );
    }

    if (posts.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Text(
          'No posts in this project',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
        ),
      );
    }

    final postSize = 140.0;
    
    return SizedBox(
      height: postSize,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: posts.length,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return CompactPostCard(
            post: posts[index],
            width: postSize,
            height: postSize,
            circular: true,
          );
        },
      ),
    );
  }
}
