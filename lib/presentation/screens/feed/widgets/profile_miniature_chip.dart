import 'package:flutter/material.dart';
import '../../../widgets/common/shadowed_text.dart';

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
    this.size = 50,
    this.spacing = 15,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: spacing),
        width: size,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile picture circle
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
              ),
              child: ClipOval(
                child: Image.network(
                  label == 'I follow'
                      ? 'https://i.pravatar.cc/150?img=1'
                      : label == 'Similar to me'
                          ? 'https://i.pravatar.cc/150?img=2'
                          : label == 'I responded to'
                              ? 'https://i.pravatar.cc/150?img=3'
                              : 'https://i.pravatar.cc/150?img=4',
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      color: Colors.white,
                      size: size * 0.6,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Username with shadow
            ShadowedText(
              text: label,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
