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
    return Padding(
      padding: const EdgeInsets.all(24.0),
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
          const SizedBox(height: 20.0),
          _buildContent(context),
        ],
      ),
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
      return Text(
        errorMessage,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
      );
    }

    if (posts.isEmpty) {
      return Text(
        'No posts in this project',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return CompactPostCard(
            post: posts[index],
            width: 160,
            height: 120,
          );
        },
      ),
    );
  }
}
