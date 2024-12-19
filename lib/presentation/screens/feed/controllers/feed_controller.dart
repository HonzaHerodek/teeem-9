import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../feed_bloc/feed_bloc.dart';
import '../feed_bloc/feed_event.dart';
import '../feed_bloc/feed_state.dart';
import '../services/feed_position_tracker.dart';
import '../services/feed_item_service.dart';

class FeedController extends ChangeNotifier {
  final FeedBloc feedBloc;
  final FeedPositionTracker positionTracker;
  final BuildContext context;
  late FeedItemService _itemService;
  FeedItemService get itemService => _itemService;

  FeedController({
    required this.feedBloc,
    required this.positionTracker,
    required this.context,
  }) {
    // Initialize with empty service
    _itemService = FeedItemService(
      posts: const [],
      projects: const [],
      isCreatingPost: false,
    );
  }

  void updateItemService(FeedItemService newService) {
    _itemService = newService;
    notifyListeners();
  }

  void selectPost(String postId) {
    positionTracker.updatePosition(
      selectedItemId: postId,
      isProject: false,
    );
    // Additional post selection logic can be added here
  }

  void selectProject(String projectId) {
    positionTracker.updatePosition(
      selectedItemId: projectId,
      isProject: true,
    );
    feedBloc.add(FeedProjectSelected(projectId));
  }

  void selectStep(String itemId, int stepIndex) {
    final position = positionTracker.currentPosition;
    if (position.selectedItemId != itemId) {
      positionTracker.updatePosition(
        selectedItemId: itemId,
        isProject: position.isProject,
      );
    }
    // Step selection logic can be expanded based on requirements
  }

  Future<void> moveToPosition(int index) async {
    if (index < 0 || index >= itemService.totalItemCount) return;
    
    await positionTracker.scrollToIndex(index);
    positionTracker.updatePosition(index: index);
  }

  Future<void> moveToItem(String itemId, {bool isProject = false}) async {
    // Wait for next frame to ensure FeedBloc state is updated
    await Future.microtask(() async {
      int targetIndex = -1;
      
      // Try multiple times with small delays to find the item
      // This helps when content is still loading or being updated
      for (int attempt = 0; attempt < 3; attempt++) {
        for (int i = 0; i < itemService.totalItemCount; i++) {
          if (isProject) {
            final project = itemService.getProjectAtPosition(i);
            if (project?.id == itemId) {
              targetIndex = i;
              break;
            }
          } else {
            final post = itemService.getPostAtPosition(i);
            if (post?.id == itemId) {
              targetIndex = i;
              break;
            }
          }
        }
        
        if (targetIndex != -1) {
          await moveToPosition(targetIndex);
          break;
        }
        
        // Wait a bit before trying again
        await Future.delayed(const Duration(milliseconds: 100));
      }
    });
  }

  void refresh() {
    feedBloc.add(const FeedRefreshed());
  }

  void loadMore() {
    feedBloc.add(const FeedLoadMore());
  }

  void likePost(String postId) {
    feedBloc.add(FeedPostLiked(postId));
  }

  void ratePost(String postId, double rating) {
    feedBloc.add(FeedPostRated(postId, rating));
  }

  @override
  void dispose() {
    positionTracker.dispose();
    super.dispose();
  }
}
