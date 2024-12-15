import 'package:flutter/material.dart';
import '../../../data/models/post_model.dart';
import '../compact_post_card.dart';

class SelectableCompactPostCard extends StatelessWidget {
  final PostModel post;
  final bool isSelected;
  final VoidCallback onToggle;
  final double width;
  final double height;

  const SelectableCompactPostCard({
    super.key,
    required this.post,
    required this.isSelected,
    required this.onToggle,
    this.width = 140,
    this.height = 140,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Stack(
        children: [
          // Base CompactPostCard
          CompactPostCard(
            post: post,
            width: width,
            height: height,
            circular: true,
          ),
          // Selection overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.green : Colors.red,
                  width: 3,
                ),
                color: isSelected 
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.1),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 40,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
