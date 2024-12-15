import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/project_model.dart';
import '../../data/models/post_model.dart';
import '../../core/di/injection.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/repositories/project_repository.dart';
import '../../presentation/screens/feed/feed_bloc/feed_bloc.dart';
import '../../presentation/screens/feed/feed_bloc/feed_event.dart';
import '../../presentation/screens/feed/feed_bloc/feed_state.dart';
import '../../presentation/widgets/circular_action_button.dart';
import 'compact_post_card.dart';

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
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  List<PostModel> _projectPosts = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProjectPosts();
  }

  @override
  void didUpdateWidget(ProjectCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.project.postIds != widget.project.postIds) {
      _fetchProjectPosts();
    }
  }

  Future<void> _fetchProjectPosts() async {
    final postRepository = getIt<PostRepository>();

    try {
      final List<PostModel> posts = [];
      for (final postId in widget.project.postIds) {
        try {
          final post = await postRepository.getPostById(postId);
          posts.add(post);
        } catch (e) {
          print('Error fetching post $postId: $e');
        }
      }

      if (mounted) {
        setState(() {
          _projectPosts = posts;
          _isLoading = false;
          _errorMessage = posts.isEmpty ? 'No posts found' : '';
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

  void _showPostSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<FeedBloc, FeedState>(
          builder: (context, state) {
            if (state is FeedSuccess) {
              // Filter out posts that are already in the project
              final availablePosts = state.posts.where(
                (post) => !widget.project.postIds.contains(post.id)
              ).toList();

              if (availablePosts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'No available posts to add',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: availablePosts.length,
                itemBuilder: (context, index) {
                  final post = availablePosts[index];
                  return ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.description),
                    onTap: () async {
                      try {
                        // Add the selected post to the project
                        context.read<FeedBloc>().add(
                          FeedAddPostToProject(
                            projectId: widget.project.id,
                            postId: post.id,
                          ),
                        );
                        Navigator.of(context).pop();
                        
                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Post added to ${widget.project.name}'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to add post: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state is FeedSuccess) {
          try {
            // Find the updated project
            final updatedProject = state.projects.firstWhere(
              (p) => p.id == widget.project.id,
              orElse: () => widget.project,
            );
            
            // If the project's posts have changed, refresh them
            if (updatedProject.postIds != widget.project.postIds) {
              _fetchProjectPosts();
            }
          } catch (e) {
            print('Error updating project card: $e');
            // Don't update if there's an error finding the project
          }
        }
      },
      child: Transform.translate(
        offset: Offset(0, -widget.elevation),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Stack(
              children: [
                // Glass effect container
                ClipRRect(
                  borderRadius: BorderRadius.circular(32.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
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
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Project name
                            Text(
                              widget.project.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 12.0),

                            // Project description
                            Text(
                              widget.project.description,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 20.0),

                            // Project posts
                            if (_isLoading)
                              const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            else if (_errorMessage.isNotEmpty)
                              Text(
                                _errorMessage,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                              )
                            else if (_projectPosts.isEmpty)
                              Text(
                                'No posts in this project',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                              )
                            else
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _projectPosts.length,
                                  itemBuilder: (context, index) {
                                    return CompactPostCard(
                                      post: _projectPosts[index],
                                      width: 160,
                                      height: 120,
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Add Post Button - Bottom Right Corner
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: CircularActionButton(
                    icon: Icons.add,
                    onPressed: _showPostSelectionBottomSheet,
                    isBold: true,
                  ),
                ),

                // Hover effect overlay
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onTap,
                      borderRadius: BorderRadius.circular(32.0),
                      splashColor: Colors.white.withOpacity(0.1),
                      highlightColor: Colors.white.withOpacity(0.05),
                      child: const SizedBox(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
