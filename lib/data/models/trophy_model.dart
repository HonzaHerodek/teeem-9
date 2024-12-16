import 'package:flutter/material.dart';

class Trophy {
  final String title;
  final String description;
  final Color color;
  final bool isAchieved;
  final String category;

  const Trophy({
    required this.title,
    required this.description,
    required this.color,
    required this.category,
    this.isAchieved = false,
  });
}

// Example trophies with distinct colors
final List<Trophy> defaultTrophies = [
  // Community Impact Trophies
  Trophy(
    title: 'Early Adopter',
    description: 'One of the first users to join the platform',
    color: Colors.amber,
    category: 'COMMUNITY IMPACT',
    isAchieved: true,
  ),
  Trophy(
    title: 'Top Contributor',
    description: 'Created high-quality content that helps others',
    color: Colors.purple,
    category: 'COMMUNITY IMPACT',
    isAchieved: true,
  ),
  Trophy(
    title: 'Team Player',
    description: 'Actively participates in community projects',
    color: Colors.blue,
    category: 'COMMUNITY IMPACT',
    isAchieved: true,
  ),
  Trophy(
    title: 'Community Leader',
    description: 'Inspires and guides the community forward',
    color: Colors.deepPurple,
    category: 'COMMUNITY IMPACT',
    isAchieved: true,
  ),
  Trophy(
    title: 'Network Builder',
    description: 'Connects and brings people together',
    color: Colors.indigo,
    category: 'COMMUNITY IMPACT',
    isAchieved: false,
  ),

  // Achievement Trophies
  Trophy(
    title: 'Innovator',
    description: 'Brings fresh ideas and approaches to projects',
    color: Colors.green,
    category: 'ACHIEVEMENTS',
    isAchieved: false,
  ),
  Trophy(
    title: 'Mentor',
    description: 'Helps guide and support other members',
    color: Colors.orange,
    category: 'ACHIEVEMENTS',
    isAchieved: false,
  ),
  Trophy(
    title: 'Problem Solver',
    description: 'Finds creative solutions to challenges',
    color: Colors.teal,
    category: 'ACHIEVEMENTS',
    isAchieved: false,
  ),
  Trophy(
    title: 'Quality Master',
    description: 'Consistently delivers exceptional work',
    color: Colors.lightBlue,
    category: 'ACHIEVEMENTS',
    isAchieved: false,
  ),
  Trophy(
    title: 'Rising Star',
    description: 'Shows remarkable growth and potential',
    color: Colors.pink,
    category: 'ACHIEVEMENTS',
    isAchieved: false,
  ),
];
