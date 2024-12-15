import 'package:equatable/equatable.dart';
import 'package:myapp/data/models/post_model.dart';
import 'package:myapp/data/models/project_model.dart';

abstract class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {
  const FeedInitial();
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

class FeedLoadingMore extends FeedState {
  final List<PostModel> posts;
  final List<ProjectModel> projects;

  const FeedLoadingMore({
    required this.posts,
    this.projects = const [],
  });

  @override
  List<Object> get props => [posts, projects];
}

class FeedSuccess extends FeedState {
  final List<PostModel> posts;
  final List<ProjectModel> projects;
  final String currentUserId;
  final String? selectedProjectId;

  const FeedSuccess({
    required this.posts,
    required this.currentUserId,
    this.projects = const [],
    this.selectedProjectId,
  });

  @override
  List<Object?> get props => [posts, projects, currentUserId, selectedProjectId];
}

class FeedFailure extends FeedState {
  final String error;

  const FeedFailure({String? error}) : error = error ?? 'An error occurred';

  @override
  List<Object> get props => [error];
}
