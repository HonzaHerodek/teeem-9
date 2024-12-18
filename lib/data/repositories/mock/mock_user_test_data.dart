import '../../../data/models/user_model.dart';
import '../../../data/models/targeting_model.dart';
import '../../../data/models/rating_model.dart';
import '../../../data/models/trait_model.dart';

class MockUserTestData {
  static List<RatingModel> createTestRatings() {
    return [
      RatingModel(
        value: 4.5,
        userId: 'user_2',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      RatingModel(
        value: 5.0,
        userId: 'user_3',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      RatingModel(
        value: 4.0,
        userId: 'user_4',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  static List<TraitModel> createTestTraits() {
    return [
      const TraitModel(
        id: 'prog_exp',
        name: 'Experience',
        iconData: '0xe8e8',
        value: '5+ years',
        category: 'programming',
        displayOrder: 0,
      ),
      const TraitModel(
        id: 'prog_lang',
        name: 'Languages',
        iconData: '0xe86f',
        value: 'Flutter, Dart',
        category: 'programming',
        displayOrder: 1,
      ),
    ];
  }

  static Map<String, UserModel> createTestUsers() {
    final users = <String, UserModel>{};
    
    // Initialize the test user that matches mock_auth_repository
    final testUser = UserModel(
      id: 'user_1',
      username: 'Test User',
      email: 'test@example.com',
      profileImage: 'https://i.pravatar.cc/150?u=test@example.com',
      bio: 'This is a test user account',
      followers: ['user_2', 'user_3'],
      following: ['user_2'],
      settings: {
        'notifications': true,
        'darkMode': false,
        'language': 'en',
      },
      targetingCriteria: TargetingCriteria(
        interests: ['coding', 'design', 'technology'],
        minAge: 18,
        maxAge: 65,
        languages: ['English'],
        experienceLevel: 'intermediate',
        skills: ['Flutter', 'Dart', 'Mobile Development'],
        industries: ['Technology', 'Software'],
      ),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      lastActive: DateTime.now(),
      ratings: createTestRatings(),
      traits: createTestTraits(),
    );

    users[testUser.id] = testUser;

    // Add additional test users
    for (var i = 2; i <= 5; i++) {
      final userId = 'user_$i';
      final ratings = List.generate(
        3,
        (index) => RatingModel(
          value: 3.0 + index.toDouble(),
          userId: 'user_${(i + index) % 5 + 1}',
          createdAt: DateTime.now().subtract(Duration(days: index)),
        ),
      );

      final user = UserModel(
        id: userId,
        username: 'User $i',
        email: 'user$i@example.com',
        profileImage: 'https://i.pravatar.cc/150?u=$userId',
        bio: 'This is the bio for User $i',
        followers: i % 2 == 0 ? ['user_1'] : [],
        following: i % 2 == 0 ? [] : ['user_1'],
        settings: {
          'notifications': true,
          'darkMode': false,
          'language': 'en',
        },
        targetingCriteria: TargetingCriteria(
          interests: ['general', 'learning'],
          languages: ['English'],
          experienceLevel: 'beginner',
        ),
        createdAt: DateTime.now().subtract(Duration(days: 30 - i)),
        lastActive: DateTime.now().subtract(Duration(minutes: i)),
        ratings: ratings,
      );

      users[userId] = user;
    }

    return users;
  }
}
