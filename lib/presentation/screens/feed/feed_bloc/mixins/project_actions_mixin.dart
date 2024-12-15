import 'package:bloc/bloc.dart';
import 'package:myapp/domain/repositories/project_repository.dart';
import '../../feed_bloc/feed_state.dart';
import '../../feed_bloc/feed_event.dart';

mixin ProjectActionsMixin on Bloc<FeedEvent, FeedState> {
  Future<void> handleProjectSelection(
    String projectId,
    ProjectRepository projectRepository,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedSuccess) return;
    
    final currentState = state as FeedSuccess;
    try {
      final project = await projectRepository.getProject(projectId);
      
      emit(FeedSuccess(
        posts: currentState.posts,
        projects: currentState.projects,
        currentUserId: currentState.currentUserId,
        selectedProjectId: projectId,
      ));
    } catch (e) {
      emit(FeedFailure(error: e.toString()));
    }
  }

  Future<void> handleAddPostToProject(
    String projectId,
    String postId,
    ProjectRepository projectRepository,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedSuccess) return;

    final currentState = state as FeedSuccess;
    try {
      final project = await projectRepository.getProject(projectId);
      final updatedProject = project.copyWith(
        postIds: [...project.postIds, postId],
        updatedAt: DateTime.now(),
      );

      await projectRepository.updateProject(updatedProject);
      final updatedProjects = await projectRepository.getProjects();

      emit(FeedSuccess(
        posts: currentState.posts,
        projects: updatedProjects,
        currentUserId: currentState.currentUserId,
        selectedProjectId: currentState.selectedProjectId,
      ));
    } catch (e) {
      emit(FeedFailure(error: e.toString()));
    }
  }

  Future<void> handleRemovePostFromProject(
    String projectId,
    String postId,
    ProjectRepository projectRepository,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedSuccess) return;

    final currentState = state as FeedSuccess;
    try {
      final project = await projectRepository.getProject(projectId);
      final updatedProject = project.copyWith(
        postIds: project.postIds.where((id) => id != postId).toList(),
        updatedAt: DateTime.now(),
      );

      await projectRepository.updateProject(updatedProject);
      final updatedProjects = await projectRepository.getProjects();

      emit(FeedSuccess(
        posts: currentState.posts,
        projects: updatedProjects,
        currentUserId: currentState.currentUserId,
        selectedProjectId: currentState.selectedProjectId,
      ));
    } catch (e) {
      emit(FeedFailure(error: e.toString()));
    }
  }
}
