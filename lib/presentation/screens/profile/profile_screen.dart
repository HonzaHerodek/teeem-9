import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../domain/repositories/post_repository.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../core/services/rating_service.dart';
import '../../widgets/error_view.dart';
import 'profile_bloc/profile_bloc.dart';
import 'profile_bloc/profile_event.dart';
import 'profile_bloc/profile_state.dart';
import 'widgets/profile_content.dart';
import 'widgets/profile_loading_overlay.dart';
import 'mixins/profile_trait_handler_mixin.dart';
import 'mixins/profile_trait_state_mixin.dart';

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

class _ProfileViewState extends State<ProfileView> with ProfileTraitStateMixin, ProfileTraitHandlerMixin {
  bool _showTraits = false;
  bool _showNetwork = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listenWhen: (previous, current) => 
            previous.user?.traits.length != current.user?.traits.length,
          listener: (context, state) {
            print('[ProfileView] Traits changed: ${state.user?.traits.length} traits');
            // Force rebuild when traits change
            setState(() {
              _showTraits = true;
              _showNetwork = false;
            });
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listenWhen: (previous, current) => 
            !previous.hasError && current.hasError,
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
        ),
      ],
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          print('[ProfileView] Building with state - isLoading: ${state.isLoading}, traits: ${state.user?.traits.length}');
          
          if (state.isInitial && state.isLoading) {
            return const ProfileLoadingOverlay(isInitialLoading: true);
          }

          if (state.user == null) {
            return ErrorView(
              message: state.error ?? 'Failed to load profile',
              onRetry: () {
                context.read<ProfileBloc>().add(const ProfileStarted());
              },
            );
          }

          return Stack(
            children: [
              ProfileContent(
                key: ValueKey('profile_content_${state.user?.traits.length}'),
                state: state,
                showTraits: _showTraits,
                showNetwork: _showNetwork,
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
                onTraitAdded: (trait) => handleTraitAdded(context, trait),
              ),
              if (state.isLoading && !state.isInitial)
                const ProfileLoadingOverlay(),
            ],
          );
        },
      ),
    );
  }
}
