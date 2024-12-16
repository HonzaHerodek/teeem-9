import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../../../core/navigation/navigation_service.dart';
import '../../../core/di/injection.dart';
import '../constants/post_widget_constants.dart';
import '../rating_stars.dart';

class OtherPostsList extends StatelessWidget {
  final List<PostModel> posts;
  final ScrollController scrollController;

  const OtherPostsList({
    super.key,
    required this.posts,
    required this.scrollController,
  });

  void _navigateToPost(PostModel post) {
    getIt<NavigationService>().navigateTo(
      AppRoutes.feed,
      arguments: {'postId': post.id},
    );
  }

  Widget _buildPostThumbnail(PostModel post) {
    final postSize = PostWidgetConstants.miniatureSize;
    final starsWidth = postSize * 0.7; // 70% of post width
    final starSize = PostWidgetConstants.starSize * 0.8; // Slightly smaller stars
    final curvature = 0.15; // Gentle curve
    final heightWithStars = postSize + (starSize * (1 + curvature));

    return SizedBox(
      width: postSize + PostWidgetConstants.horizontalMargin * 2,
      height: heightWithStars,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Post thumbnail
          Positioned(
            left: PostWidgetConstants.horizontalMargin,
            bottom: 0,
            child: Container(
              width: postSize,
              height: postSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: PostWidgetConstants.defaultShadows,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      post.title,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Stars positioned at the top with enough space for curve
          Positioned(
            top: 0,
            left: PostWidgetConstants.horizontalMargin + (postSize - starsWidth) / 2,
            child: SizedBox(
              width: starsWidth,
              child: RatingStars(
                rating: post.ratingStats.averageRating,
                size: starSize,
                color: Colors.amber,
                frameWidth: starsWidth,
                sizeModifier: 0, // No size variation for compact view
                starSpacing: 2.0, // Tight spacing
                curvature: curvature,
                isInteractive: false,
              ),
            ),
          ),
          // Make the entire area tappable
          Positioned(
            left: PostWidgetConstants.horizontalMargin,
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _navigateToPost(post),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: SizedBox(
                  width: postSize,
                  height: postSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final starSize = PostWidgetConstants.starSize * 0.8;
    final curvature = 0.15;
    final totalHeight = PostWidgetConstants.miniatureSize + (starSize * (1 + curvature));
    
    return Container(
      height: totalHeight,
      clipBehavior: Clip.none,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: posts.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) => _buildPostThumbnail(posts[index]),
      ),
    );
  }
}
