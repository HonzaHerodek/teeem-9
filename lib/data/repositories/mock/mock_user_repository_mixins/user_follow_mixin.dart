import '../../../../data/models/user_model.dart';
import '../../../../core/errors/app_exception.dart';

mixin UserFollowMixin {
  Map<String, UserModel> get users;
  Duration get delay;
  
  Future<void> followUser(String userId) async {
    await Future.delayed(delay);
    final currentUserId = 'user_1'; // Mock current user
    if (!users.containsKey(userId)) {
      throw NotFoundException('User not found');
    }

    final currentUser = users[currentUserId];
    final targetUser = users[userId];

    if (currentUser != null && targetUser != null) {
      users[currentUserId] = currentUser.copyWith(
        following: [...currentUser.following, userId],
      );
      users[userId] = targetUser.copyWith(
        followers: [...targetUser.followers, currentUserId],
      );
    }
  }

  Future<void> unfollowUser(String userId) async {
    await Future.delayed(delay);
    final currentUserId = 'user_1'; // Mock current user

    final currentUser = users[currentUserId];
    final targetUser = users[userId];

    if (currentUser != null && targetUser != null) {
      users[currentUserId] = currentUser.copyWith(
        following: currentUser.following.where((id) => id != userId).toList(),
      );
      users[userId] = targetUser.copyWith(
        followers: targetUser.followers.where((id) => id != currentUserId).toList(),
      );
    }
  }

  Stream<List<UserModel>> getFollowers(String userId) async* {
    await Future.delayed(delay);
    final user = users[userId];
    if (user != null) {
      yield user.followers
          .map((id) => users[id])
          .whereType<UserModel>()
          .toList();
    } else {
      yield [];
    }
  }

  Stream<List<UserModel>> getFollowing(String userId) async* {
    await Future.delayed(delay);
    final user = users[userId];
    if (user != null) {
      yield user.following
          .map((id) => users[id])
          .whereType<UserModel>()
          .toList();
    } else {
      yield [];
    }
  }
}
