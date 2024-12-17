import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final LayerLink layerLink;
  final bool isActive;
  final VoidCallback onPressed;

  const FilterButton({
    super.key,
    required this.layerLink,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: layerLink,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? Colors.pink : Colors.transparent,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                isActive ? Icons.close : Icons.filter_list,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
