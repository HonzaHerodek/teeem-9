import 'package:flutter/material.dart';

class FilterRelationChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isSelected;
  final double height;
  final double spacing;
  final bool useWhiteStyle;

  const FilterRelationChip({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.isSelected = false,
    this.height = 35,
    this.spacing = 15,
    this.useWhiteStyle = false,
  });

  @override
  Widget build(BuildContext context) {
    final contentColor = useWhiteStyle ? Colors.black87 : Colors.white.withOpacity(0.9);
    final backgroundColor = useWhiteStyle 
        ? Colors.transparent 
        : Colors.white.withOpacity(isSelected ? 0.25 : 0.15);
    final borderColor = useWhiteStyle 
        ? Colors.transparent 
        : Colors.white.withOpacity(0.2);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        margin: EdgeInsets.only(right: spacing / 2),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(height / 2),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: contentColor,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: contentColor,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
