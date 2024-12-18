import 'package:flutter/material.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/models/trophy_model.dart';
import '../../../../core/errors/app_exception.dart';

mixin UserAnalyticsMixin {
  Map<String, UserModel> get users;
  Duration get delay;

  Future<Map<String, dynamic>> getUserAnalytics(String userId) async {
    await Future.delayed(delay);
    final user = users[userId];
    if (user == null) {
      throw NotFoundException('User not found');
    }

    return {
      'followers': user.followers.length,
      'following': user.following.length,
      'engagement': {
        'likes': 100,
        'comments': 50,
        'shares': 25,
      },
      'growth': {
        'followersGrowth': 10,
        'engagementGrowth': 15,
      },
    };
  }

  Future<List<Trophy>> getTrophies() async {
    await Future.delayed(delay);
    try {
      // You might want to move this to a separate file if the list grows
      return [
        Trophy(
          title: 'First Post',
          description: 'Created your first post',
          color: Colors.amber,
          category: 'ACHIEVEMENTS',
          isAchieved: true,
        ),
        Trophy(
          title: 'Popular Post',
          description: 'Got 100+ likes on a post',
          color: Colors.purple,
          category: 'ACHIEVEMENTS',
          isAchieved: false,
        ),
        Trophy(
          title: 'Active User',
          description: 'Posted every day for a week',
          color: Colors.blue,
          category: 'ACHIEVEMENTS',
          isAchieved: false,
        ),
      ];
    } catch (e) {
      throw AppException('Failed to fetch trophies');
    }
  }
}
