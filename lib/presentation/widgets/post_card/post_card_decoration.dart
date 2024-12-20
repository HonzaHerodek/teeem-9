import 'package:flutter/material.dart';

class PostCardDecoration {
  static BoxDecoration circularGradient(double size) {
    return BoxDecoration(
      shape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.1),
          Colors.transparent,
          Colors.black.withOpacity(0.3),
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 35,
          spreadRadius: 8,
          offset: const Offset(0, 15),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 25,
          spreadRadius: 5,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: const Color(0xFF2A1635).withOpacity(0.2),
          blurRadius: 20,
          spreadRadius: 5,
        ),
      ],
    );
  }

  static const BoxDecoration circularClip = BoxDecoration(
    shape: BoxShape.circle,
  );
}
