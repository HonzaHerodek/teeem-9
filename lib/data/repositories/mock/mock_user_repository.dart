import 'package:injectable/injectable.dart';
import '../../../core/errors/app_exception.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../models/user_model.dart';
import '../../models/trait_model.dart';
import 'mock_user_test_data.dart';
import 'mock_user_repository_mixins/user_follow_mixin.dart';
import 'mock_user_repository_mixins/user_settings_mixin.dart';
import 'mock_user_repository_mixins/user_analytics_mixin.dart';

@LazySingleton(as: UserRepository)
class MockUserRepository
    with UserFollowMixin, UserSettingsMixin, UserAnalyticsMixin
    implements UserRepository {
  @override
  final Map<String, UserModel> users = {};
  
  @override
  final delay = const Duration(milliseconds: 500);

  MockUserRepository() {
    users.addAll(MockUserTestData.createTestUsers());
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(delay);
    final currentUser = users['user_1'];
    print('[MockUserRepo] Getting current user with ${currentUser?.traits.length} traits');
    if (currentUser?.traits.isNotEmpty == true) {
      print('[MockUserRepo] Current traits: ${currentUser?.traits.map((t) => '${t.category}:${t.name}:${t.value}')}');
    }
    return currentUser != null ? _createDeepCopy(currentUser) : null;
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    await Future.delayed(delay);
    final user = users[userId];
    if (user == null) {
      throw NotFoundException('User not found');
    }
    return _createDeepCopy(user);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    print('[MockUserRepo] Starting user update');
    print('[MockUserRepo] New user traits: ${user.traits.map((t) => '${t.category}:${t.name}:${t.value}')}');
    
    await Future.delayed(delay);
    
    if (!users.containsKey(user.id)) {
      throw NotFoundException('User not found');
    }
    
    final oldUser = users[user.id];
    print('[MockUserRepo] Current user traits: ${oldUser?.traits.map((t) => '${t.category}:${t.name}:${t.value}')}');
    
    final oldTraitsCount = oldUser?.traits.length ?? 0;
    
    // Create a deep copy of the user
    final updatedUser = _createDeepCopy(user);
    
    // Update the user in the map
    users[user.id] = updatedUser;
    
    // Verify the update
    final verifyUser = users[user.id];
    final newTraitsCount = verifyUser?.traits.length ?? 0;
    
    print('[MockUserRepo] Traits count - Before: $oldTraitsCount, After: $newTraitsCount');
    
    if (verifyUser == null) {
      throw AppException('Failed to verify user update');
    }
    
    // Verify traits were properly updated
    final traitsMatch = _verifyTraits(user.traits, verifyUser.traits);
    if (!traitsMatch) {
      print('[MockUserRepo] Trait verification failed');
      print('Expected: ${user.traits.map((t) => '${t.category}:${t.name}:${t.value}')}');
      print('Got: ${verifyUser.traits.map((t) => '${t.category}:${t.name}:${t.value}')}');
      throw AppException('Trait update verification failed');
    }
    
    print('[MockUserRepo] User update verified successfully');
    print('[MockUserRepo] Updated user traits: ${verifyUser.traits.map((t) => '${t.category}:${t.name}:${t.value}')}');
  }

  @override
  Future<List<UserModel>> searchUsers(String query) async {
    await Future.delayed(delay);
    final queryLower = query.toLowerCase();
    return users.values
        .where((user) =>
            user.username.toLowerCase().contains(queryLower) ||
            user.email.toLowerCase().contains(queryLower))
        .map(_createDeepCopy)
        .toList();
  }

  @override
  Stream<UserModel> getUserStream(String userId) async* {
    await Future.delayed(delay);
    final user = users[userId];
    if (user == null) {
      throw NotFoundException('User not found');
    }
    yield _createDeepCopy(user);
  }

  // Helper method to create a deep copy of UserModel
  UserModel _createDeepCopy(UserModel user) {
    return UserModel(
      id: user.id,
      username: user.username,
      email: user.email,
      profileImage: user.profileImage,
      bio: user.bio,
      followers: List.from(user.followers),
      following: List.from(user.following),
      settings: user.settings != null ? Map.from(user.settings!) : null,
      targetingCriteria: user.targetingCriteria,
      createdAt: user.createdAt,
      lastActive: user.lastActive,
      ratings: List.from(user.ratings),
      traits: List.from(user.traits),
    );
  }

  // Helper method to verify traits lists match
  bool _verifyTraits(List<TraitModel> expected, List<TraitModel> actual) {
    if (expected.length != actual.length) {
      return false;
    }

    for (var i = 0; i < expected.length; i++) {
      final e = expected[i];
      final a = actual[i];
      if (e.id != a.id ||
          e.category != a.category ||
          e.name != a.name ||
          e.value != a.value) {
        return false;
      }
    }

    return true;
  }
}
