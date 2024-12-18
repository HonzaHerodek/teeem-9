import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/post_repository.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../core/services/rating_service.dart';
import '../../widgets/error_view.dart';
import '../../widgets/sliding_panel.dart';
import '../../widgets/animated_gradient_background.dart';
import '../../widgets/post_creation/in_feed_post_creation.dart';
import '../profile/profile_screen.dart';
import 'feed_bloc/feed_bloc.dart';
import 'feed_bloc/feed_event.dart';
import 'feed_bloc/feed_state.dart';
import 'services/filter_service.dart';
import 'widgets/feed_header.dart';
import 'widgets/feed_content.dart';
import 'widgets/feed_action_buttons.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedBloc(
        postRepository: getIt<PostRepository>(),
        projectRepository: getIt<ProjectRepository>(),
        authRepository: getIt<AuthRepository>(),
        filterService: getIt<FilterService>(),
        ratingService: getIt<RatingService>(),
      )..add(const FeedStarted()),
      child: const FeedView(),
    );
  }
}

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  bool _isProfileOpen = false;
  bool _isCreatingPost = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<InFeedPostCreationState> _postCreationKey =
      GlobalKey<InFeedPostCreationState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent) {
      context.read<FeedBloc>().add(const FeedRefreshed());
    } else if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      context.read<FeedBloc>().add(const FeedLoadMore());
    }
  }

  void _toggleProfile() {
    setState(() {
      _isProfileOpen = !_isProfileOpen;
    });
  }

  void _toggleCreatePost() {
    setState(() {
      _isCreatingPost = !_isCreatingPost;
    });
  }

  void _handlePostCreationComplete(bool success) {
    setState(() {
      _isCreatingPost = false;
    });
    if (success) {
      context.read<FeedBloc>().add(const FeedRefreshed());
    }
  }

  Future<void> _handleActionButton() async {
    if (_isCreatingPost) {
      final state = _postCreationKey.currentState;
      if (state != null) {
        await state.save();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Could not save post'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      _toggleCreatePost();
    }
  }

  List<Rect> _getExcludedAreas(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return [
      Rect.fromLTWH(
        0,
        size.height - bottomPadding - 88,
        size.width,
        88 + bottomPadding,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    const headerHeight = 64.0;

    return Scaffold(
      body: Stack(
        children: [
          // Background and Content
          AnimatedGradientBackground(
            child: BlocBuilder<FeedBloc, FeedState>(
              builder: (context, state) {
                if (state is FeedInitial || state is FeedLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                }

                if (state is FeedFailure) {
                  return ErrorView(
                    message: state.error,
                    onRetry: () {
                      context.read<FeedBloc>().add(const FeedStarted());
                    },
                  );
                }

                if (state is FeedSuccess) {
                  return MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: FeedContent(
                      scrollController: _scrollController,
                      posts: state.posts,
                      projects: state.projects,
                      currentUserId: state.currentUserId,
                      isCreatingPost: _isCreatingPost,
                      postCreationKey: _postCreationKey,
                      onCancel: _toggleCreatePost,
                      onComplete: _handlePostCreationComplete,
                      topPadding: topPadding + headerHeight,
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          // Header (on top)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FeedHeader(),
          ),
          // Action Buttons
          FeedActionButtons(
            isCreatingPost: _isCreatingPost,
            onProfileTap: _toggleProfile,
            onActionButtonTap: _handleActionButton,
          ),
          // Profile Panel
          SlidingPanel(
            isOpen: _isProfileOpen,
            onClose: _toggleProfile,
            excludeFromOverlay: _getExcludedAreas(context),
            child: const ProfileScreen(),
          ),
        ],
      ),
    );
  }
}
