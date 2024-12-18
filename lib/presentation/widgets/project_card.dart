import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../core/di/injection.dart';
import '../../data/models/project_model.dart';
import '../../domain/repositories/post_repository.dart';
import '../../presentation/screens/feed/feed_bloc/feed_bloc.dart';
import '../../presentation/screens/feed/feed_bloc/feed_state.dart';
import 'common/glass_container.dart';
import 'project/project_header.dart';
import 'project/project_post_list.dart';
import 'project/project_action_buttons.dart';
import 'project/project_post_selection_service.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final String? currentUserId;
  final VoidCallback? onTap;
  final double elevation;
  static const Duration _animationDuration = Duration(milliseconds: 300);
  static const Curve _animationCurve = Curves.easeInOut;

  const ProjectCard({
    super.key,
    required this.project,
    this.currentUserId,
    this.onTap,
    this.elevation = 0,
  });

  void _handleSettingsPressed(BuildContext context, ProjectPostSelectionService service, FeedState state) {
    if (service.isSelectionMode) {
      service.handlePostsAdded(context);
    } else if (state is FeedSuccess) {
      service.enterSelectionMode(state.posts);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to edit posts at this time'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProjectPostSelectionService(
        postRepository: getIt<PostRepository>(),
        projectId: project.id,
        projectName: project.name,
        initialPostIds: project.postIds,
      ),
      child: BlocConsumer<FeedBloc, FeedState>(
        listenWhen: (previous, current) {
          if (previous is FeedSuccess && current is FeedSuccess) {
            final prevProject = previous.projects.firstWhere(
              (p) => p.id == project.id,
              orElse: () => project,
            );
            final currentProject = current.projects.firstWhere(
              (p) => p.id == project.id,
              orElse: () => project,
            );
            return prevProject.postIds != currentProject.postIds;
          }
          return false;
        },
        listener: (context, state) {
          if (state is FeedSuccess) {
            final updatedProject = state.projects.firstWhere(
              (p) => p.id == project.id,
              orElse: () => project,
            );
            if (updatedProject.postIds != project.postIds) {
              context.read<ProjectPostSelectionService>().updatePostIds(updatedProject.postIds);
            }
          }
        },
        builder: (context, state) {
          return Consumer<ProjectPostSelectionService>(
            builder: (context, service, _) {
              return Transform.translate(
                offset: Offset(0, -elevation),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: GlassContainer(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ProjectHeader(
                          project: project,
                          service: service,
                          onTap: onTap,
                          onSettingsPressed: (context) => _handleSettingsPressed(context, service, state),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 16.0),
                          child: Text(
                            project.description,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (service.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          )
                        else if (service.errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              service.errorMessage,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                            ),
                          )
                        else ...[
                          if (service.projectPosts.isNotEmpty)
                            ProjectPostList(
                              posts: service.projectPosts,
                              isSelectable: service.isSelectionMode,
                              service: service,
                              isProjectPosts: true,
                              title: service.isSelectionMode ? 'Project Posts' : '',
                            ),
                          if (service.isSelectionMode) ...[
                            AnimatedContainer(
                              duration: _animationDuration,
                              curve: _animationCurve,
                              height: service.isSelectionMode ? 16.0 : 0.0,
                              child: const SizedBox(),
                            ),
                            ProjectPostList(
                              posts: service.availablePosts,
                              isSelectable: true,
                              service: service,
                              isProjectPosts: false,
                              title: 'Available Posts',
                            ),
                          ],
                        ],
                        ProjectActionButtons(
                          project: project,
                          currentUserId: currentUserId,
                          service: service,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
