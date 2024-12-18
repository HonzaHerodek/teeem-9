import 'package:flutter/material.dart';

class TargetIcon extends StatelessWidget {
  final VoidCallback onTap;
  final bool isActive;

  const TargetIcon({
    super.key,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Theme.of(context).primaryColor : Colors.transparent,
      ),
      child: IconButton(
        icon: Icon(
          isActive ? Icons.group : Icons.group_outlined,
          color: Colors.white,
        ),
        onPressed: onTap,
      ),
    );
  }
}
