import '../../../../data/models/user_model.dart';

mixin UserSettingsMixin {
  Map<String, UserModel> get users;
  Duration get delay;

  Future<void> updateUserSettings(Map<String, dynamic> settings) async {
    await Future.delayed(delay);
    final currentUserId = 'user_1'; // Mock current user
    final user = users[currentUserId];
    if (user != null) {
      users[currentUserId] = user.copyWith(
        settings: {...user.settings ?? {}, ...settings},
      );
    }
  }

  Future<void> updateNotificationSettings(Map<String, bool> settings) async {
    await Future.delayed(delay);
    final currentUserId = 'user_1'; // Mock current user
    final user = users[currentUserId];
    if (user != null) {
      final currentSettings = user.settings ?? {};
      users[currentUserId] = user.copyWith(
        settings: {...currentSettings, 'notifications': settings},
      );
    }
  }

  Future<void> updateProfileImage(String imagePath) async {
    await Future.delayed(delay);
    final currentUserId = 'user_1'; // Mock current user
    final user = users[currentUserId];
    if (user != null) {
      users[currentUserId] = user.copyWith(
        profileImage: 'https://i.pravatar.cc/150?u=$currentUserId&new=true',
      );
    }
  }

  Future<bool> checkUsername(String username) async {
    await Future.delayed(delay);
    return !users.values.any(
      (user) => user.username.toLowerCase() == username.toLowerCase(),
    );
  }

  Future<void> deleteAccount() async {
    await Future.delayed(delay);
    final currentUserId = 'user_1'; // Mock current user
    users.remove(currentUserId);
  }
}
