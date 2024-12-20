import 'package:flutter/material.dart';
import '../group_chip.dart';
import '../../controllers/feed_header_controller.dart';

class FeedHeaderGroupsSection extends StatelessWidget {
  final FeedHeaderController headerController;

  const FeedHeaderGroupsSection({
    super.key,
    required this.headerController,
  });

  List<(String, List<GroupProfileInfo>)> _getSampleGroups() {
    // Sample groups with different layouts
    return [
      // Two profiles side by side
      (
        'Design Team',
        [
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=11',
            username: 'sarah.ui',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=12',
            username: 'mike.ux',
          ),
        ],
      ),
      // Three profiles in triangle
      (
        'Frontend',
        [
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=13',
            username: 'alex.dev',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=14',
            username: 'emma.code',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=15',
            username: 'james.web',
          ),
        ],
      ),
      // Four profiles in square
      (
        'Mobile Team',
        [
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=16',
            username: 'lisa.ios',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=17',
            username: 'tom.android',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=18',
            username: 'anna.flutter',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=19',
            username: 'david.react',
          ),
        ],
      ),
      // Six profiles in grid
      (
        'Backend Team',
        List.generate(6, (index) => GroupProfileInfo(
          imageUrl: 'https://i.pravatar.cc/150?img=${20 + index}',
          username: 'dev${index + 1}',
        )),
      ),
      // Many profiles (showing +4)
      (
        'All Engineers',
        List.generate(10, (index) => GroupProfileInfo(
          imageUrl: 'https://i.pravatar.cc/150?img=${26 + index}',
          username: 'eng${index + 1}',
        )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (!headerController.state.isSearchVisible) {
      return const SizedBox.shrink();
    }

    final groups = _getSampleGroups();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final (name, profiles) = groups[index];
        return GroupChip(
          groupName: name,
          profiles: profiles,
          onTap: () {
            // Handle group selection
          },
          isSelected: false,
        );
      },
    );
  }
}
