import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../domain/repositories/post_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../core/services/rating_service.dart';
import '../../widgets/error_view.dart';
import '../../widgets/profile_posts_grid.dart';
import 'widgets/profile_header_section.dart';
import 'widgets/profile_traits_view.dart';
import 'widgets/profile_network_view.dart';
import 'profile_bloc/profile_bloc.dart';
import 'profile_bloc/profile_event.dart';
import 'profile_bloc/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        userRepository: getIt<UserRepository>(),
        postRepository: getIt<PostRepository>(),
        ratingService: getIt<RatingService>(),
      )..add(const ProfileStarted()),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(0.75),
              Colors.black.withOpacity(0.65),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 25,
              spreadRadius: 8,
            ),
          ],
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: const SafeArea(
              child: ProfileView(),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _showTraits = false;
  bool _showNetwork = false;
  bool _isAddingTrait = false;

  Widget _buildContent(BuildContext context, ProfileState state) {
    if (_showTraits) {
      return ProfileTraitsView(
        traits: state.user?.traits ?? [],
        onTraitAdded: (trait) async {
          setState(() => _isAddingTrait = true);
          try {
            context.read<ProfileBloc>().add(ProfileTraitAdded(trait));
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Added ${trait.name} trait'),
                backgroundColor: Colors.green,
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to add trait: $e'),
                backgroundColor: Colors.red,
              ),
            );
          } finally {
            setState(() => _isAddingTrait = false);
          }
        },
        isLoading: _isAddingTrait,
      );
    } else if (_showNetwork) {
      return const ProfileNetworkView();
    }
    
    return const SizedBox.shrink(); // Return empty widget instead of username text
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading && !_isAddingTrait) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          );
        }

        if (state.user == null) {
          return ErrorView(
            message: state.error ?? 'Failed to load profile',
            onRetry: () {
              context.read<ProfileBloc>().add(const ProfileStarted());
            },
          );
        }

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  ProfileHeaderSection(
                    state: state,
                    onTraitsPressed: () {
                      setState(() {
                        _showTraits = !_showTraits;
                        _showNetwork = false;
                      });
                    },
                    onNetworkPressed: () {
                      setState(() {
                        _showNetwork = !_showNetwork;
                        _showTraits = false;
                      });
                    },
                    showTraits: _showTraits,
                    showNetwork: _showNetwork,
                  ),
                  _buildContent(context, state),
                  if (_showTraits || _showNetwork) const SizedBox(height: 16),
                  if (!_showTraits && !_showNetwork) ...[
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
                      onLike: (post) {
                        // TODO: Implement like functionality
                      },
                      onComment: (post) {
                        // TODO: Implement comment functionality
                      },
                      onShare: (post) {
                        // TODO: Implement share functionality
                      },
                      onRate: (rating, post) {
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
      },
    );
  }
}
