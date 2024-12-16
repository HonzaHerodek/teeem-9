import '../../../../data/models/targeting_model.dart';
import '../../../widgets/filtering/models/filter_type.dart';

abstract class FeedEvent {
  const FeedEvent();

  List<Object?> get props => [];
}

class FeedStarted extends FeedEvent {
  const FeedStarted();
}

class FeedRefreshed extends FeedEvent {
  const FeedRefreshed();
}

class FeedLoadMore extends FeedEvent {
  const FeedLoadMore();
}

class FeedPostLiked extends FeedEvent {
  final String postId;

  const FeedPostLiked(this.postId);

  @override
  List<Object?> get props => [postId];
}

class FeedPostUnliked extends FeedEvent {
  final String postId;

  const FeedPostUnliked(this.postId);

  @override
  List<Object?> get props => [postId];
}

class FeedPostDeleted extends FeedEvent {
  final String postId;

  const FeedPostDeleted(this.postId);

  @override
  List<Object?> get props => [postId];
}

class FeedPostHidden extends FeedEvent {
  final String postId;

  const FeedPostHidden(this.postId);

  @override
  List<Object?> get props => [postId];
}

class FeedPostSaved extends FeedEvent {
  final String postId;

  const FeedPostSaved(this.postId);

  @override
  List<Object?> get props => [postId];
}

class FeedPostUnsaved extends FeedEvent {
  final String postId;

  const FeedPostUnsaved(this.postId);

  @override
  List<Object?> get props => [postId];
}

class FeedPostReported extends FeedEvent {
  final String postId;
  final String reason;

  const FeedPostReported(this.postId, this.reason);

  @override
  List<Object?> get props => [postId, reason];
}

class FeedPostRated extends FeedEvent {
  final String postId;
  final double rating;

  const FeedPostRated(this.postId, this.rating);

  @override
  List<Object?> get props => [postId, rating];
}

class FeedFilterChanged extends FeedEvent {
  final FilterType filterType;

  const FeedFilterChanged(this.filterType);

  @override
  List<Object?> get props => [filterType];
}

class FeedTargetingFilterChanged extends FeedEvent {
  final TargetingCriteria? targetingCriteria;

  const FeedTargetingFilterChanged(this.targetingCriteria);

  @override
  List<Object?> get props => [targetingCriteria];
}

class FeedSearchChanged extends FeedEvent {
  final String query;

  const FeedSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

// Project-related events
class FeedProjectSelected extends FeedEvent {
  final String projectId;

  const FeedProjectSelected(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class FeedProjectCreated extends FeedEvent {
  final String name;
  final String description;

  const FeedProjectCreated({
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [name, description];
}

class FeedAddPostToProject extends FeedEvent {
  final String projectId;
  final String postId;

  const FeedAddPostToProject({
    required this.projectId,
    required this.postId,
  });

  @override
  List<Object?> get props => [projectId, postId];
}

class FeedRemovePostFromProject extends FeedEvent {
  final String projectId;
  final String postId;

  const FeedRemovePostFromProject({
    required this.projectId,
    required this.postId,
  });

  @override
  List<Object?> get props => [projectId, postId];
}

class FeedBatchAddPostsToProject extends FeedEvent {
  final String projectId;
  final List<String> postIds;

  const FeedBatchAddPostsToProject({
    required this.projectId,
    required this.postIds,
  });

  @override
  List<Object?> get props => [projectId, postIds];
}

class FeedBatchRemovePostsFromProject extends FeedEvent {
  final String projectId;
  final List<String> postIds;

  const FeedBatchRemovePostsFromProject({
    required this.projectId,
    required this.postIds,
  });

  @override
  List<Object?> get props => [projectId, postIds];
}

class FeedBatchOperations extends FeedEvent {
  final String projectId;
  final List<String> postsToRemove;
  final List<String> postsToAdd;

  const FeedBatchOperations({
    required this.projectId,
    required this.postsToRemove,
    required this.postsToAdd,
  });

  @override
  List<Object?> get props => [projectId, postsToRemove, postsToAdd];
}

class FeedProjectLiked extends FeedEvent {
  final String projectId;

  const FeedProjectLiked(this.projectId);

  @override
  List<Object?> get props => [projectId];
}

class FeedProjectUnliked extends FeedEvent {
  final String projectId;

  const FeedProjectUnliked(this.projectId);

  @override
  List<Object?> get props => [projectId];
}
