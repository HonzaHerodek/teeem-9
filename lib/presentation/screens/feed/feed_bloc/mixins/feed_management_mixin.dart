import 'package:bloc/bloc.dart';
import 'package:myapp/domain/repositories/auth_repository.dart';
import 'package:myapp/domain/repositories/post_repository.dart';
import 'package:myapp/domain/repositories/project_repository.dart';
import '../../services/filter_service.dart';
import '../feed_state.dart';
import '../feed_event.dart';

mixin FeedManagementMixin on Bloc<FeedEvent, FeedState> {
  Future<void> loadFeed({
    required AuthRepository authRepository,
    required PostRepository postRepository,
    required ProjectRepository projectRepository,
    required FilterService filterService,
    required Emitter<FeedState> emit,
    bool isRefresh = false,
    bool isLoadMore = false,
  }) async {
    try {
      // Get current user
      final currentUser = await authRepository.getCurrentUser();
      if (currentUser == null) throw Exception('User not authenticated');

      // Get posts and projects
      final posts = await postRepository.getPosts();
      final projects = await projectRepository.getProjects();
      final filteredPosts = filterService.filterPosts(posts, currentUser);

      // Handle different loading scenarios
      if (isLoadMore && state is FeedSuccess) {
        final currentState = state as FeedSuccess;
        emit(FeedSuccess(
          posts: [...currentState.posts, ...filteredPosts],
          projects: projects,
          currentUserId: currentUser.id,
          selectedProjectId: currentState.selectedProjectId,
        ));
      } else {
        emit(FeedSuccess(
          posts: filteredPosts,
          projects: projects,
          currentUserId: currentUser.id,
          selectedProjectId: state is FeedSuccess 
            ? (state as FeedSuccess).selectedProjectId 
            : null,
        ));
      }
    } catch (e) {
      emit(FeedFailure(error: e.toString()));
    }
  }

  Future<void> handleFeedStart({
    required AuthRepository authRepository,
    required PostRepository postRepository,
    required ProjectRepository projectRepository,
    required FilterService filterService,
    required Emitter<FeedState> emit,
  }) async {
    emit(const FeedLoading());
    await loadFeed(
      authRepository: authRepository,
      postRepository: postRepository,
      projectRepository: projectRepository,
      filterService: filterService,
      emit: emit,
    );
  }

  Future<void> handleFeedRefresh({
    required AuthRepository authRepository,
    required PostRepository postRepository,
    required ProjectRepository projectRepository,
    required FilterService filterService,
    required Emitter<FeedState> emit,
  }) async {
    if (state is! FeedSuccess) emit(const FeedLoading());
    await loadFeed(
      authRepository: authRepository,
      postRepository: postRepository,
      projectRepository: projectRepository,
      filterService: filterService,
      emit: emit,
      isRefresh: true,
    );
  }

  Future<void> handleFeedLoadMore({
    required AuthRepository authRepository,
    required PostRepository postRepository,
    required ProjectRepository projectRepository,
    required FilterService filterService,
    required Emitter<FeedState> emit,
  }) async {
    if (state is! FeedSuccess) return;
    
    final currentState = state as FeedSuccess;
    emit(FeedLoadingMore(
      posts: currentState.posts,
      projects: currentState.projects,
    ));
    
    await loadFeed(
      authRepository: authRepository,
      postRepository: postRepository,
      projectRepository: projectRepository,
      filterService: filterService,
      emit: emit,
      isLoadMore: true,
    );
  }
}
