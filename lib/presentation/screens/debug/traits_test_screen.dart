import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/traits/user_trait_model.dart';
import '../../widgets/post_card.dart';

class TraitsTestScreen extends StatelessWidget {
  const TraitsTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final testPost = PostModel(
      id: 'test_post',
      userId: 'test_user',
      username: 'Test User',
      userProfileImage: 'https://i.pravatar.cc/150?u=test_user',
      title: 'Test Post',
      description: 'This is a test post to verify traits implementation',
      steps: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      likes: [],
      comments: [],
      status: PostStatus.active,
      ratings: [],
      userTraits: [
        const UserTraitModel(
          id: 'exp_1',
          traitTypeId: '1',
          value: 'Brown',
          displayOrder: 0,
        ),
        const UserTraitModel(
          id: 'eye_1',
          traitTypeId: '2',
          value: 'Blue',
          displayOrder: 1,
        ),
        const UserTraitModel(
          id: 'hobby_1',
          traitTypeId: '3',
          value: 'Gaming',
          displayOrder: 2,
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Traits Test'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: PostCard(
          post: testPost,
          currentUserId: 'test_user',
          onLike: () {},
          onComment: () {},
          onShare: () {},
          onRate: (_) {},
        ),
      ),
    );
  }
}
