import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/project_model.dart';
import '../../data/models/post_model.dart';
import '../../core/di/injection.dart';
import '../../domain/repositories/post_repository.dart';
import '../../presentation/screens/feed/feed_bloc/feed_bloc.dart';
import '../../presentation/screens/feed/feed_bloc/feed_event.dart';
import '../../presentation/screens/feed/feed_bloc/feed_state.dart';
import '../widgets/circular_action_button.dart';
import 'compact_post_card.dart';
import 'project/selectable_compact_post_card.dart';

class ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback? onTap;
  final double elevation;

  const ProjectCard({
    super.key,
    required this.project,
    this.onTap,
    this.elevation = 0,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  final _postRepository = getIt<PostRepository>();
  List<PostModel> _projectPosts = [];
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isSelectionMode = false;
  final Set<String> _selectedPostIds = {};
  List<PostModel> _availablePosts = [];
  static const double _postSize = 140.0;

  @override
  void initState() {
    super.initState();
    _fetchProjectPosts();
  }

  @override
  void didUpdateWidget(ProjectCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.project != widget.project) {
      _fetchProjectPosts();
    }
  }

  Future<void> _fetchProjectPosts() async {
    try {
      final List<PostModel> posts = [];
      for (final postId in widget.project.postIds) {
        try {
          final post = await _postRepository.getPostById(postId);
          posts.add(post);
        } catch (e) {
          print('Error fetching post $postId: $e');
        }
      }

      if (mounted) {
        setState(() {
          _projectPosts = posts;
          _isLoading = false;
          _errorMessage = '';
        });
      }
    } catch (e) {
      print('Unexpected error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'An unexpected error occurred';
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title.toUpperCase(),
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w200,
          letterSpacing: 2.0,
          fontSize: 24,
        ),
      ),
    );
  }

  void _handleEditPosts() {
    final state = context.read<FeedBloc>().state;
    if (state is! FeedSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to edit posts at this time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_isSelectionMode) {
      // Confirm selection
      if (_selectedPostIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select at least one post'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      for (final postId in _selectedPostIds) {
        context.read<FeedBloc>().add(
          FeedAddPostToProject(
            projectId: widget.project.id,
            postId: postId,
          ),
        );
      }

      // Trigger a feed refresh to ensure we have the latest data
      context.read<FeedBloc>().add(const FeedRefreshed());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_selectedPostIds.length} posts added to ${widget.project.name}'),
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _isSelectionMode = false;
        _selectedPostIds.clear();
        _availablePosts = [];
      });
    } else {
      // Enter selection mode
      final availablePosts = state.posts.where(
        (post) => !widget.project.postIds.contains(post.id)
      ).toList();

      if (availablePosts.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No available posts to add'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      setState(() {
        _isSelectionMode = true;
        _availablePosts = availablePosts;
        _selectedPostIds.clear();
      });
    }
  }

  void _togglePostSelection(String postId) {
    setState(() {
      if (_selectedPostIds.contains(postId)) {
        _selectedPostIds.remove(postId);
      } else {
        _selectedPostIds.add(postId);
      }
    });
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Text(
          _errorMessage,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Project Posts
        if (_projectPosts.isEmpty && !_isSelectionMode)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'No posts in this project',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
            ),
          )
        else if (_projectPosts.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Project Posts'),
              SizedBox(
                height: _postSize,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _projectPosts.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: CompactPostCard(
                        post: _projectPosts[index],
                        width: _postSize,
                        height: _postSize,
                        circular: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

        // Selection Mode UI
        if (_isSelectionMode) ...[
          const SizedBox(height: 24.0),
          _buildSectionHeader('Available Posts'),
          SizedBox(
            height: _postSize,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _availablePosts.length,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final post = _availablePosts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: SelectableCompactPostCard(
                    post: post,
                    width: _postSize,
                    height: _postSize,
                    isSelected: _selectedPostIds.contains(post.id),
                    onToggle: () => _togglePostSelection(post.id),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedBloc, FeedState>(
      listenWhen: (previous, current) {
        if (previous is FeedSuccess && current is FeedSuccess) {
          final prevProject = previous.projects.firstWhere(
            (p) => p.id == widget.project.id,
            orElse: () => widget.project,
          );
          final currentProject = current.projects.firstWhere(
            (p) => p.id == widget.project.id,
            orElse: () => widget.project,
          );
          return prevProject != currentProject;
        }
        return false;
      },
      listener: (context, state) {
        if (state is FeedSuccess) {
          final updatedProject = state.projects.firstWhere(
            (p) => p.id == widget.project.id,
            orElse: () => widget.project,
          );
          if (updatedProject.postIds != widget.project.postIds) {
            _fetchProjectPosts();
          }
        }
      },
      child: Transform.translate(
        offset: Offset(0, -widget.elevation),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Stack(
            children: [
              GestureDetector(
                onTap: _isSelectionMode ? null : widget.onTap,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.0),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Background with blur
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                      ),
                      // Content without clipping
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.project.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 12.0),
                                Text(
                                  widget.project.description,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: Colors.white.withOpacity(0.8),
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          _buildContent(),
                          const SizedBox(height: 24.0),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: CircularActionButton(
                  icon: _isSelectionMode ? Icons.check : Icons.edit,
                  onPressed: _handleEditPosts,
                  isBold: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
