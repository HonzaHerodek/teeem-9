import 'package:flutter/material.dart';
import '../group_chip.dart';
import '../../controllers/feed_header_controller.dart';
import 'feed_header_filters_section.dart';

class FeedHeaderGroupsSection extends StatelessWidget {
  final FeedHeaderController headerController;

  const FeedHeaderGroupsSection({
    super.key,
    required this.headerController,
  });

  List<(String, List<GroupProfileInfo>)> _getSampleGroups() {
    // Sample groups with different layouts and realistic names
    return [
      // Two profiles side by side
      (
        'UI/UX Team',
        [
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=11',
            username: 'emily.design',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=32',
            username: 'marcus.ux',
          ),
        ],
      ),
      // Three profiles in triangle
      (
        'React Devs',
        [
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=28',
            username: 'alex.frontend',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=14',
            username: 'sophia.react',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=25',
            username: 'nathan.js',
          ),
        ],
      ),
      // Four profiles in square
      (
        'Mobile Squad',
        [
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=36',
            username: 'lisa.swift',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=57',
            username: 'raj.android',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=48',
            username: 'claire.flutter',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=29',
            username: 'mike.mobile',
          ),
        ],
      ),
      // Six profiles in grid
      (
        'Cloud Team',
        [
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=51',
            username: 'sarah.devops',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=42',
            username: 'james.aws',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=53',
            username: 'emma.cloud',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=44',
            username: 'david.k8s',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=55',
            username: 'anna.sre',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=46',
            username: 'tom.infra',
          ),
        ],
      ),
      // Many profiles (showing +4)
      (
        'Core Platform',
        [
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=61',
            username: 'chris.backend',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=52',
            username: 'maya.java',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=63',
            username: 'daniel.go',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=54',
            username: 'olivia.rust',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=65',
            username: 'lucas.scala',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=56',
            username: 'zoe.python',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=67',
            username: 'ryan.cpp',
          ),
          GroupProfileInfo(
            imageUrl: 'https://i.pravatar.cc/150?img=58',
            username: 'ava.elixir',
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final groups = _getSampleGroups();
    final groupChips = groups.map((group) {
      final (name, profiles) = group;
      return GroupChip(
        groupName: name,
        profiles: profiles,
        onTap: () {
          // Handle group selection
        },
        isSelected: false,
      );
    }).toList();

    // Use the reusable filter section for layout with reduced spacing
    return FeedHeaderFiltersSection(
      headerController: headerController,
      height: 80,
      spacing: 10, // Reduced from 20 to 10
      children: groupChips,
    );
  }
}
