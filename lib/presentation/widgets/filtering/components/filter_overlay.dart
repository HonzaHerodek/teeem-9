import 'package:flutter/material.dart';
import '../models/filter_type.dart';

class FilterOverlay extends StatelessWidget {
  final LayerLink layerLink;
  final Animation<double> animation;
  final Function(FilterType) onFilterSelected;
  final VoidCallback onDismiss;

  const FilterOverlay({
    super.key,
    required this.layerLink,
    required this.animation,
    required this.onFilterSelected,
    required this.onDismiss,
  });

  Widget _buildFilterItem(FilterType filterType) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Opacity(
            opacity: animation.value,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.pink.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Tooltip(
                  message: filterType.displayName,
                  child: IconButton(
                    icon: Icon(filterType.icon, color: Colors.white),
                    onPressed: () => onFilterSelected(filterType),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: onDismiss,
            child: Container(color: Colors.transparent),
          ),
        ),
        Positioned(
          child: CompositedTransformFollower(
            link: layerLink,
            targetAnchor: Alignment.topRight,
            followerAnchor: Alignment.topRight,
            offset: const Offset(0, 48),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildFilterItem(FilterType.group),
                    _buildFilterItem(FilterType.pair),
                    _buildFilterItem(FilterType.self),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
