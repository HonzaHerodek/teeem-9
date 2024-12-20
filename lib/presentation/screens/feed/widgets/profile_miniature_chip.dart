import 'package:flutter/material.dart';

class ProfileMiniatureChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;
  final double size;
  final double spacing;

  const ProfileMiniatureChip({
    super.key,
    required this.label,
    this.onTap,
    this.isSelected = false,
    this.size = 56,
    this.spacing = 15,
  });

  String get username {
    // Map filter types to realistic usernames
    switch (label) {
      case 'I follow':
        return 'alex.designer';
      case 'Similar to me':
        return 'sarah.codes';
      case 'I responded to':
        return 'mike.developer';
      case 'My followers':
        return 'emma.techie';
      case 'Recently active':
        return 'james.creative';
      case 'Top creators':
        return 'lisa.maker';
      case 'Recommended':
        return 'david.builds';
      case 'New users':
        return 'nina.creates';
      default:
        return 'username';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: spacing),
        width: size * 1.4, // Wider container to accommodate longer usernames
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile picture circle
            SizedBox(
              width: size,
              height: size,
              child: Stack(
                children: [
                  ClipOval(
                    child: Stack(
                      children: [
                        // Image
                        Image.network(
                          // Different images for each profile
                          label == 'I follow'
                              ? 'https://i.pravatar.cc/150?img=1'
                              : label == 'Similar to me'
                                  ? 'https://i.pravatar.cc/150?img=2'
                                  : label == 'I responded to'
                                      ? 'https://i.pravatar.cc/150?img=3'
                                      : label == 'My followers'
                                          ? 'https://i.pravatar.cc/150?img=4'
                                          : label == 'Recently active'
                                              ? 'https://i.pravatar.cc/150?img=5'
                                              : label == 'Top creators'
                                                  ? 'https://i.pravatar.cc/150?img=6'
                                                  : label == 'Recommended'
                                                      ? 'https://i.pravatar.cc/150?img=7'
                                                      : 'https://i.pravatar.cc/150?img=8',
                          width: size,
                          height: size,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.white.withOpacity(0.15),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: size * 0.6,
                              ),
                            );
                          },
                        ),
                        // Gradient overlay
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          height: size * 0.5,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                  Colors.black.withOpacity(0.9),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Selection indicator
                  if (isSelected)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // Username below image
            Text(
              username,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
                height: 1,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
