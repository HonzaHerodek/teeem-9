import 'package:flutter/material.dart';
import '../models/filter_type.dart';
import '../../../../presentation/widgets/common/gradient_box_border.dart';

class FilterChip extends StatelessWidget {
  final FilterType filterType;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterChip({
    super.key,
    required this.filterType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected 
              ? theme.primaryColor.withOpacity(0.95)
              : theme.cardColor.withOpacity(0.95),
          borderRadius: BorderRadius.circular(20),
          border: GradientBoxBorder(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.1),
              ],
            ),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              filterType.icon,
              color: isSelected 
                  ? Colors.white 
                  : theme.primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              filterType.displayName,
              style: TextStyle(
                color: isSelected 
                    ? Colors.white 
                    : theme.textTheme.bodyLarge?.color,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularFilterChip extends StatelessWidget {
  final FilterType filterType;
  final bool isSelected;
  final VoidCallback onTap;

  const CircularFilterChip({
    super.key,
    required this.filterType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected 
              ? theme.primaryColor.withOpacity(0.95)
              : theme.cardColor.withOpacity(0.95),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            filterType.icon,
            color: isSelected 
                ? Colors.white 
                : theme.primaryColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class FilterChipGroup extends StatelessWidget {
  final List<FilterType> filterTypes;
  final FilterType selectedFilter;
  final ValueChanged<FilterType> onFilterSelected;
  final bool circular;

  const FilterChipGroup({
    super.key,
    required this.filterTypes,
    required this.selectedFilter,
    required this.onFilterSelected,
    this.circular = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: 20), // Initial padding
          ...filterTypes.map((type) {
            final chip = circular
                ? CircularFilterChip(
                    filterType: type,
                    isSelected: selectedFilter == type,
                    onTap: () => onFilterSelected(type),
                  )
                : FilterChip(
                    filterType: type,
                    isSelected: selectedFilter == type,
                    onTap: () => onFilterSelected(type),
                  );
            
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: chip,
            );
          }).toList(),
          const SizedBox(width: 20), // Final padding
        ],
      ),
    );
  }
}
