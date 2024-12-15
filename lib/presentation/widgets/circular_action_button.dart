import 'package:flutter/material.dart';

class CircularActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isBold;
  final double size;

  const CircularActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isBold = false,
    this.size = 56.0,
  });

  @override
  Widget build(BuildContext context) {
    const double strokeWidth = 2.0;

    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: strokeWidth,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: Center(
                child: Icon(
                  icon,
                  key: ValueKey('action_button_icon_$icon'),
                  color: Colors.white,
                  size: isBold
                      ? size * 0.57
                      : size * 0.43, // Maintain icon size ratio
                  weight: isBold ? 700 : 400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
