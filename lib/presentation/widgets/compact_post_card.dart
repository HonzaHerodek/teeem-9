import 'package:flutter/material.dart';
import '../../data/models/post_model.dart';

class CompactPostCard extends StatelessWidget {
  final PostModel post;
  final double width;
  final double height;

  const CompactPostCard({
    super.key,
    required this.post,
    this.width = 120,
    this.height = 120,
  });

  String? _getFirstImageUrl() {
    return post.steps
        .firstWhere(
          (step) => step.imageUrl != null,
          orElse: () => PostStep(
            id: '',
            type: StepType.text,
            title: '',
            imageUrl: null,
          ),
        )
        .imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _getFirstImageUrl();

    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background or image
            if (imageUrl != null)
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.7),
              ),
            
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),

            // Content
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    post.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70,
                          fontSize: 10,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
