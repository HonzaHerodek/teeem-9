import 'package:bloc/bloc.dart';
import 'package:myapp/data/models/post_model.dart';
import 'package:myapp/data/models/project_model.dart';
import 'package:myapp/domain/repositories/auth_repository.dart';
import 'package:myapp/domain/repositories/project_repository.dart';
import 'package:myapp/presentation/widgets/filtering/services/filter_service.dart';
import 'package:myapp/domain/repositories/post_repository.dart';
import 'package:myapp/core/services/rating_service.dart';
import 'feed_event.dart';
import 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository _postRepository;
  final ProjectRepository _projectRepository;
  final FilterService _filterService;
  final RatingService _ratingService;
  final AuthRepository _authRepository;

  FeedBloc({
    required PostRepository postRepository,
    required ProjectRepository projectRepository,
    required AuthRepository authRepository,
    required FilterService filterService,
    required RatingService ratingService,
  })  : _postRepository = postRepository,
        _projectRepository = projectRepository,
        _filterService = filterService,
        _ratingService = ratingService,
        _authRepository = authRepository,
        super(const FeedInitial()) {
    on<FeedStarted>(_onStarted);
    on<FeedRefreshed>(_onRefreshed);
    on<FeedLoadMore>(_onLoadMore);
    on<FeedPostLiked>(_onPostLiked);
    on<FeedPostUnliked>(_onPostUnliked);
    on<FeedPostDeleted>(_onPostDeleted);
    on<FeedPostHidden>(_onPostHidden);
    on<FeedPostSaved>(_onPostSaved);
    on<FeedPostUnsaved>(_onPostUnsaved);
    on<FeedPostReported>(_onPostReported);
    on<FeedPostRated>(_onPostRated);
    on<FeedFilterChanged>(_onFilterChanged);
    on<FeedTargetingFilterChanged>(_onTargetingFilterChanged);
    on<FeedSearchChanged>(_onSearchChanged);
    
    // Minimal project-related events
    on<FeedProjectSelected>(_onProjectSelected);
  }

  Future<void> _onStarted(FeedStarted event, Emitter<FeedState> emit) async {
    emit(const FeedLoading());
    try {
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) throw Exception('User not authenticated');
      
      final posts = await _postRepository.getPosts();
      final projects = await _projectRepository.getProjects();
      final filteredPosts = _filterService.filterPosts(posts, currentUser);
      
      emit(FeedSuccess(
        posts: filteredPosts, 
        projects: projects,
        currentUserId: currentUser.id,
      ));
    } catch (e) {
      emit(FeedFailure(error: e.toString()));
    }
  }

  Future<void> _onRefreshed(FeedRefreshed event, Emitter<FeedState> emit) async {
    if (state is! FeedSuccess) emit(const FeedLoading());
    try {
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) throw Exception('User not authenticated');
      
      final posts = await _postRepository.getPosts();
      final projects = await _projectRepository.getProjects();
      final filteredPosts = _filterService.filterPosts(posts, currentUser);
      
      emit(FeedSuccess(
        posts: filteredPosts, 
        projects: projects,
        currentUserId: currentUser.id,
      ));
    } catch (e) {
      emit(FeedFailure(error: e.toString()));
    }
  }

  Future<void> _onLoadMore(FeedLoadMore event, Emitter<FeedState> emit) async {
    if (state is FeedSuccess) {
      final currentState = state as FeedSuccess;
      emit(FeedLoadingMore(
        posts: currentState.posts,
        projects: currentState.projects,
      ));
      try {
        final currentUser = await _authRepository.getCurrentUser();
        if (currentUser == null) throw Exception('User not authenticated');
        
        final posts = await _postRepository.getPosts();
        final filteredPosts = _filterService.filterPosts(posts, currentUser);
        
        emit(FeedSuccess(
          posts: [...currentState.posts, ...filteredPosts],
          projects: currentState.projects,
          currentUserId: currentUser.id,
        ));
      } catch (e) {
        emit(FeedFailure(error: e.toString()));
      }
    }
  }

  Future<void> _updatePostState(
    String postId, 
    Future<void> Function() updateAction, 
    Emitter<FeedState> emit
  ) async {
    if (state is! FeedSuccess) return;
    
    final currentState = state as FeedSuccess;
    try {
      await updateAction();
      final updatedPost = await _postRepository.getPostById(postId);
      final updatedPosts = currentState.posts.map((post) {
        return post.id == postId ? updatedPost : post;
      }).toList();
      
      emit(FeedSuccess(
        posts: updatedPosts,
        projects: currentState.projects,
        currentUserId: currentState.currentUserId,
      ));
    } catch (e) {
      emit(FeedFailure(error: e.toString()));
    }
  }

  Future<void> _onPostLiked(FeedPostLiked event, Emitter<FeedState> emit) async {
    await _updatePostState(
      event.postId, 
      () => _postRepository.likePost(event.postId, (state as FeedSuccess).currentUserId), 
      emit
    );
  }

  Future<void> _onPostUnliked(FeedPostUnliked event, Emitter<FeedState> emit) async {
    await _updatePostState(
      event.postId, 
      () => _postRepository.unlikePost(event.postId, (state as FeedSuccess).currentUserId), 
      emit
    );
  }

  Future<void> _onPostDeleted(FeedPostDeleted event, Emitter<FeedState> emit) async {
    if (state is! FeedSuccess) return;
    
    final currentState = state as FeedSuccess;
    try {
      await _postRepository.deletePost(event.postId);
      final updatedPosts = currentState.posts.where((post) => post.id != event.postId).toList();
      
      emit(FeedSuccess(
        posts: updatedPosts,
        projects: currentState.projects,
        currentUserId: currentState.currentUserId,
      ));
    } catch (e) {
      emit(FeedFailure(error: e.toString()));
    }
  }

  Future<void> _onPostHidden(FeedPostHidden event, Emitter<FeedState> emit) async {
    await _updatePostState(
      event.postId, 
      () => _postRepository.hidePost(event.postId, (state as FeedSuccess).currentUserId), 
      emit
    );
  }

  Future<void> _onPostSaved(FeedPostSaved event, Emitter<FeedState> emit) async {
    await _updatePostState(
      event.postId, 
      () => _postRepository.savePost(event.postId, (state as FeedSuccess).currentUserId), 
      emit
    );
  }

  Future<void> _onPostUnsaved(FeedPostUnsaved event, Emitter<FeedState> emit) async {
    await _updatePostState(
      event.postId, 
      () => _postRepository.unsavePost(event.postId, (state as FeedSuccess).currentUserId), 
      emit
    );
  }

  Future<void> _onPostReported(FeedPostReported event, Emitter<FeedState> emit) async {
    await _updatePostState(
      event.postId, 
      () => _postRepository.reportPost(
        event.postId, 
        (state as FeedSuccess).currentUserId,
        event.reason
      ), 
      emit
    );
  }

  Future<void> _onPostRated(FeedPostRated event, Emitter<FeedState> emit) async {
    if (state is! FeedSuccess) return;
    
    final currentState = state as FeedSuccess;
    try {
      await _ratingService.ratePost(
        event.postId, 
        currentState.currentUserId, 
        event.rating
      );
      final updatedPost = await _postRepository.getPostById(event.postId);
      final updatedPosts = currentState.posts.map((post) {
        return post.id == event.postId ? updatedPost : post;
      }).toList();
      
      emit(FeedSuccess(
        posts: updatedPosts,
        projects: currentState.projects,
        currentUserId: currentState.currentUserId,
      ));
    } catch (e) {
      emit(FeedFailure(error: e.toString()));
    }
  }

  void _onFilterChanged(FeedFilterChanged event, Emitter<FeedState> emit) async {
    if (state is! FeedSuccess) return;
    
    final currentState = state as FeedSuccess;
    try {
      _filterService.setFilter(event.filterType);
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) throw Exception('User not authenticated');
      
      final filteredPosts = _filterService.filterPosts(currentState.posts, currentUser);
      
      emit(FeedSuccess(
        posts: filteredPosts,
        projects: currentState.projects,
        currentUserId: currentState.currentUserId,
      ));
    } catch (e) {
      emit(FeedFailure(error: e.toString()));
    }
  }

  void _onTargetingFilterChanged(
    FeedTargetingFilterChanged event, 
    Emitter<FeedState> emit
  ) {
    // Placeholder for future implementation
  }

  void _onSearchChanged(FeedSearchChanged event, Emitter<FeedState> emit) {
    if (state is! FeedSuccess) return;
    
    final currentState = state as FeedSuccess;
    final query = event.query.toLowerCase();
    
    final filteredPosts = currentState.posts
        .where((post) =>
            post.title.toLowerCase().contains(query) ||
            post.description.toLowerCase().contains(query))
        .toList();
    
    final filteredProjects = currentState.projects
        .where((project) =>
            project.name.toLowerCase().contains(query) ||
            project.description.toLowerCase().contains(query))
        .toList();
    
    emit(FeedSuccess(
      posts: filteredPosts,
      projects: filteredProjects,
      currentUserId: currentState.currentUserId,
    ));
  }

  Future<void> _onProjectSelected(
    FeedProjectSelected event, 
    Emitter<FeedState> emit
  ) async {
    if (state is! FeedSuccess) return;
    
    final currentState = state as FeedSuccess;
    try {
      final project = await _projectRepository.getProject(event.projectId);
      final projectPosts = await Future.wait(
        project.postIds.map((id) => _postRepository.getPostById(id)),
      );
      
      emit(FeedSuccess(
        posts: projectPosts,
        projects: currentState.projects,
        currentUserId: currentState.currentUserId,
        selectedProjectId: event.projectId,
      ));
    } catch (e) {
      emit(FeedFailure(error: e.toString()));
    }
  }
}
