import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/post_model.dart';
import '../../../domain/repositories/post_repository.dart';
import '../../screens/feed/feed_bloc/feed_bloc.dart';
import '../../screens/feed/feed_bloc/feed_event.dart';
import '../../screens/feed/feed_bloc/feed_state.dart';

class ProjectPostSelectionService extends ChangeNotifier {
  final PostRepository _postRepository;
  final String projectId;
  final String projectName;
  List<String> _currentPostIds;

  List<PostModel> _projectPosts = [];
  List<PostModel> _availablePosts = [];
  final Set<String> _selectedPostIds = {};
  bool _isLoading = true;
  bool _isSelectionMode = false;
  String _errorMessage = '';

  ProjectPostSelectionService({
    required PostRepository postRepository,
    required this.projectId,
    required this.projectName,
    required List<String> initialPostIds,
  }) : _postRepository = postRepository,
      _currentPostIds = List.from(initialPostIds) {
    _fetchProjectPosts();
  }

  // Getters
  List<PostModel> get projectPosts => List.unmodifiable(_projectPosts);
  List<PostModel> get availablePosts => List.unmodifiable(_availablePosts);
  Set<String> get selectedPostIds => Set.unmodifiable(_selectedPostIds);
  bool get isLoading => _isLoading;
  bool get isSelectionMode => _isSelectionMode;
  String get errorMessage => _errorMessage;

  Future<void> _fetchProjectPosts() async {
    if (_currentPostIds.isEmpty) {
      _isLoading = false;
      _projectPosts = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final posts = await Future.wait(
        _currentPostIds.map((id) => _postRepository.getPostById(id).catchError((e) {
          print('Error fetching post $id: $e');
          return null;
        })),
      );

      _projectPosts = posts.whereType<PostModel>().toList();
      _isLoading = false;
      _errorMessage = '';
      notifyListeners();
    } catch (e) {
      print('Unexpected error: $e');
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      _projectPosts = [];
      notifyListeners();
    }
  }

  void togglePostSelection(String postId) {
    if (_selectedPostIds.contains(postId)) {
      _selectedPostIds.remove(postId);
    } else {
      _selectedPostIds.add(postId);
    }
    notifyListeners();
  }

  void enterSelectionMode(List<PostModel> feedPosts) {
    _isSelectionMode = true;
    _availablePosts = feedPosts.where(
      (post) => !_currentPostIds.contains(post.id)
    ).toList();
    _selectedPostIds.clear();
    notifyListeners();
  }

  void exitSelectionMode() {
    _isSelectionMode = false;
    _selectedPostIds.clear();
    _availablePosts = [];
    notifyListeners();
  }

  void handlePostsAdded(BuildContext context) {
    if (_selectedPostIds.isEmpty) {
      exitSelectionMode();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No changes made'),
          backgroundColor: Colors.grey,
        ),
      );
      return;
    }

    // Handle removing selected project posts
    final selectedProjectPosts = _selectedPostIds.where(
      (id) => _currentPostIds.contains(id)
    );
    
    for (final postId in selectedProjectPosts) {
      context.read<FeedBloc>().add(
        FeedRemovePostFromProject(
          projectId: projectId,
          postId: postId,
        ),
      );
    }

    // Handle adding selected available posts
    final selectedAvailablePosts = _selectedPostIds.where(
      (id) => !_currentPostIds.contains(id)
    );

    for (final postId in selectedAvailablePosts) {
      context.read<FeedBloc>().add(
        FeedAddPostToProject(
          projectId: projectId,
          postId: postId,
        ),
      );
    }

    // Trigger a feed refresh to ensure we have the latest data
    context.read<FeedBloc>().add(const FeedRefreshed());

    final addedCount = selectedAvailablePosts.length;
    final removedCount = selectedProjectPosts.length;
    
    String message = '';
    if (addedCount > 0 && removedCount > 0) {
      message = '$addedCount posts added and $removedCount posts removed from $projectName';
    } else if (addedCount > 0) {
      message = '$addedCount posts added to $projectName';
    } else {
      message = '$removedCount posts removed from $projectName';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );

    exitSelectionMode();
  }

  void updateProjectPosts(List<PostModel> posts) {
    _projectPosts = List.from(posts);
    notifyListeners();
  }

  void refreshPosts() {
    _fetchProjectPosts();
  }

  void updatePostIds(List<String> newPostIds) {
    _currentPostIds = List.from(newPostIds);
    _fetchProjectPosts();
  }
}
