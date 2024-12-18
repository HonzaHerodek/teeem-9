import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  final int? notificationCount;
  final VoidCallback onTap;
  final bool isActive;

  const NotificationIcon({
    super.key,
    this.notificationCount,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.pink : Colors.transparent,
          ),
          child: IconButton(
            icon: Icon(
              isActive ? Icons.notifications : Icons.notifications_outlined,
              color: Colors.white,
            ),
            onPressed: onTap,
          ),
        ),
        if (notificationCount != null && notificationCount! > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.pink,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                notificationCount! > 99 ? '99+' : notificationCount!.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
