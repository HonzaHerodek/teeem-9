import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../profile_bloc/profile_bloc.dart';
import '../profile_bloc/profile_event.dart';
import '../profile_bloc/profile_state.dart';
import '../../../../data/models/trait_model.dart';
import 'profile_header_section.dart';
import 'profile_traits_view.dart';
import 'profile_network_view.dart';
import '../../../widgets/profile_posts_grid.dart';

class ProfileContent extends StatelessWidget {
  final ProfileState state;
  final bool showTraits;
  final bool showNetwork;
  final VoidCallback onTraitsPressed;
  final VoidCallback onNetworkPressed;
  final Function(TraitModel) onTraitAdded;

  const ProfileContent({
    super.key,
    required this.state,
    required this.showTraits,
    required this.showNetwork,
    required this.onTraitsPressed,
    required this.onNetworkPressed,
    required this.onTraitAdded,
  });

  Widget _buildExpandableContent() {
    if (showTraits) {
      print('[ProfileContent] Building traits view with ${state.user?.traits.length} traits');
      print('[ProfileContent] Current traits: ${state.user?.traits.map((t) => '${t.category}:${t.name}:${t.value}')}');
      
      return ProfileTraitsView(
        key: ValueKey('traits_view_${state.user?.traits.length}_${DateTime.now().millisecondsSinceEpoch}'),
        traits: state.user?.traits ?? [],
        onTraitAdded: (trait) {
          print('[ProfileContent] Trait added callback received: ${trait.id}');
          onTraitAdded(trait);
        },
        isLoading: state.isLoading,
      );
    } else if (showNetwork) {
      return const ProfileNetworkView();
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    print('[ProfileContent] Building with showTraits: $showTraits, traits count: ${state.user?.traits.length}');
    
    return CustomScrollView(
      key: ValueKey('profile_content_${state.user?.traits.length}_${showTraits}_${showNetwork}'),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              ProfileHeaderSection(
                state: state,
                onTraitsPressed: onTraitsPressed,
                onNetworkPressed: onNetworkPressed,
                showTraits: showTraits,
                showNetwork: showNetwork,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey('expandable_content_${showTraits}_${showNetwork}_${state.user?.traits.length}'),
                  child: _buildExpandableContent(),
                ),
              ),
              if (showTraits || showNetwork) 
                const SizedBox(height: 16),
              if (!showTraits && !showNetwork) ...[
                Text(
                  state.user?.username ?? '',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              const Divider(color: Colors.white24),
              if (state.userPosts.isNotEmpty)
                ProfilePostsGrid(
                  posts: state.userPosts,
                  currentUserId: state.user!.id,
                  onLike: (_) {},
                  onComment: (_) {},
                  onShare: (_) {},
                  onRate: (rating, _) {
                    context.read<ProfileBloc>().add(
                      ProfileRatingReceived(rating, state.user!.id),
                    );
                  },
                ),
            ],
          ),
        ),
        if (state.userPosts.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'No posts yet',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
      ],
    );
  }
}
