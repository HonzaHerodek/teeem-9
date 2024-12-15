import 'package:bloc/bloc.dart';
import 'package:myapp/data/models/post_model.dart';
import 'package:myapp/domain/repositories/post_repository.dart';
import 'package:myapp/core/services/rating_service.dart';
import '../../feed_bloc/feed_state.dart';
import '../../feed_bloc/feed_event.dart';

mixin PostActionsMixin on Bloc<FeedEvent, FeedState> {
  Future<void> emitUpdatedState(
    FeedSuccess currentState,
    Future<List<PostModel>> Function() updateFunction,
    Emitter<FeedState> emit,
  ) async {
    try {
      final updatedPosts = await updateFunction();
      emit(FeedSuccess(
        posts: updatedPosts,
        projects: currentState.projects,
        currentUserId: currentState.currentUserId,
        selectedProjectId: currentState.selectedProjectId,
      ));
    } catch (e) {
      emit(FeedFailure(error: e.toString()));
    }
  }

  Future<void> handlePostAction(
    String postId,
    Future<void> Function() action,
    PostRepository postRepository,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedSuccess) return;
    final currentState = state as FeedSuccess;
    
    await emitUpdatedState(
      currentState,
      () async {
        await action();
        final updatedPost = await postRepository.getPostById(postId);
        return currentState.posts.map((post) {
          return post.id == postId ? updatedPost : post;
        }).toList();
      },
      emit,
    );
  }

  Future<void> handlePostDeletion(
    String postId,
    PostRepository postRepository,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedSuccess) return;
    final currentState = state as FeedSuccess;
    
    await emitUpdatedState(
      currentState,
      () async {
        await postRepository.deletePost(postId);
        return currentState.posts.where((post) => post.id != postId).toList();
      },
      emit,
    );
  }

  Future<void> handlePostRating(
    String postId,
    double rating,
    RatingService ratingService,
    PostRepository postRepository,
    Emitter<FeedState> emit,
  ) async {
    if (state is! FeedSuccess) return;
    final currentState = state as FeedSuccess;
    
    await emitUpdatedState(
      currentState,
      () async {
        await ratingService.ratePost(
          postId,
          currentState.currentUserId,
          rating,
        );
        final updatedPost = await postRepository.getPostById(postId);
        return currentState.posts.map((post) {
          return post.id == postId ? updatedPost : post;
        }).toList();
      },
      emit,
    );
  }
}
