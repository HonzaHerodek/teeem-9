import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/post_model.dart';
import '../screens/profile/profile_bloc/profile_bloc.dart';
import '../screens/profile/profile_bloc/profile_event.dart';
import 'compact_post_card.dart';

class PostRowHeader extends StatelessWidget {
  final String title;
  final IconData? backgroundIcon;

  const PostRowHeader({
    super.key,
    required this.title,
    this.backgroundIcon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (backgroundIcon != null)
            Positioned(
              left: screenWidth / 2 - 45,
              top: -10,
              child: Container(
                width: 90,
                height: 90,
                child: Icon(
                  backgroundIcon!,
                  size: 80,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w100,
              letterSpacing: 1.2,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePostsGrid extends StatelessWidget {
  final List<PostModel> posts;
  final String currentUserId;
  final Function(PostModel) onLike;
  final Function(PostModel) onComment;
  final Function(PostModel) onShare;
  final Function(double, PostModel) onRate;

  const ProfilePostsGrid({
    super.key,
    required this.posts,
    required this.currentUserId,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onRate,
  });

  Widget _buildPostRow(
    BuildContext context, {
    required String title,
    required List<PostModel> posts,
    IconData? backgroundIcon,
    bool showHeartButton = false,
  }) {
    const double postSize = 140.0;
    const double rowHeight = 140.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PostRowHeader(
          title: title,
          backgroundIcon: backgroundIcon,
        ),
        SizedBox(
          height: rowHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return CompactPostCard(
                post: post,
                width: postSize,
                height: postSize,
                circular: true,
                showHeartButton: showHeartButton,
                onUnsave: showHeartButton ? () {
                  context.read<ProfileBloc>().add(ProfilePostUnsaved(post.id));
                } : null,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final savedPosts = posts.take(3).toList();
    final unfinishedPosts = posts.skip(3).take(3).toList();
    final createdPosts = posts.skip(1).take(3).toList();
    final completedPosts = posts.skip(2).take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPostRow(
          context,
          title: 'Saved',
          posts: savedPosts,
          backgroundIcon: Icons.favorite_rounded,
          showHeartButton: true,
        ),
        const SizedBox(height: 24),
        _buildPostRow(
          context,
          title: 'Unfinished',
          posts: unfinishedPosts,
          backgroundIcon: Icons.pending_rounded,
        ),
        const SizedBox(height: 24),
        _buildPostRow(
          context,
          title: 'Created',
          posts: createdPosts,
          backgroundIcon: Icons.add_circle_rounded,
        ),
        const SizedBox(height: 24),
        _buildPostRow(
          context,
          title: 'Completed',
          posts: completedPosts,
          backgroundIcon: Icons.check_circle_rounded,
        ),
      ],
    );
  }
}
