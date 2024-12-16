import 'package:flutter/material.dart';
import '../../../widgets/circular_action_button.dart';

class FeedActionButtons extends StatelessWidget {
  final bool isCreatingPost;
  final VoidCallback onProfileTap;
  final VoidCallback onActionButtonTap;

  const FeedActionButtons({
    super.key,
    required this.isCreatingPost,
    required this.onProfileTap,
    required this.onActionButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: MediaQuery.of(context).padding.bottom + 16,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircularActionButton(
              icon: Icons.person,
              onPressed: onProfileTap,
              strokeWidth: 1.5,
            ),
            CircularActionButton(
              icon: isCreatingPost ? Icons.check : Icons.add,
              onPressed: onActionButtonTap,
              isBold: true,
              strokeWidth: 4.0, // Increased from 3.0 to 4.0
            ),
          ],
        ),
      ),
    );
  }
}
