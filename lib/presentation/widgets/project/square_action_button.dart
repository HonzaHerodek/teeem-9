import 'package:flutter/material.dart';

class SquareActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isBold;
  final double size;

  const SquareActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isBold = false,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    const double strokeWidth = 1.0; // Reduced from 2.0 to 1.0
    const double borderRadius = 12.0; // Highly curved corners for square

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white,
          width: strokeWidth,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              key: ValueKey('action_button_icon_$icon'),
              color: Colors.white,
              size: isBold ? size * 0.6 : size * 0.5,
              weight: isBold ? 700 : 400,
            ),
          ),
        ),
      ),
    );
  }
}
