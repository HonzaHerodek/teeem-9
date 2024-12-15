import 'package:flutter/material.dart';
import '../../../widgets/circular_action_button.dart';
import '../../../widgets/user_avatar.dart';
import '../../../widgets/rating_stars.dart';
import '../profile_bloc/profile_state.dart';

class ProfileHeaderSection extends StatelessWidget {
  final ProfileState state;
  final VoidCallback onTraitsPressed;
  final VoidCallback onNetworkPressed;
  final bool showTraits;
  final bool showNetwork;

  const ProfileHeaderSection({
    Key? key,
    required this.state,
    required this.onTraitsPressed,
    required this.onNetworkPressed,
    required this.showTraits,
    required this.showNetwork,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = state.user;
    if (user == null) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 20),
        if (state.ratingStats != null) ...[
          RatingStars(
            rating: state.ratingStats!.averageRating,
            size: 36,
            color: Colors.amber,
            distribution: state.ratingStats!.ratingDistribution,
            totalRatings: state.ratingStats!.totalRatings,
            showRatingText: true,
          ),
          const SizedBox(height: 16),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularActionButton(
              icon: Icons.psychology,
              onPressed: onTraitsPressed,
              isSelected: showTraits,
            ),
            const SizedBox(width: 16),
            UserAvatar(
              imageUrl: user.profileImage,
              name: user.username,
              size: 100,
            ),
            const SizedBox(width: 16),
            CircularActionButton(
              icon: Icons.people,
              onPressed: onNetworkPressed,
              isSelected: showNetwork,
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
