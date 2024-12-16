import 'package:flutter/material.dart';
import 'dart:math' as math;

class RatingCountStar extends StatelessWidget {
  final int count;
  final double size;

  const RatingCountStar({
    super.key,
    required this.count,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[850],
      ),
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          // Black star in background
          CustomPaint(
            size: Size(size * 0.85, size * 0.85), // Star slightly smaller than circle
            painter: StarPainter(
              color: Colors.black,
              borderColor: Colors.black,
            ),
          ),
          // Number on top
          Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                color: Colors.amber,
                fontSize: size * 0.5, // Even larger font size
                fontWeight: FontWeight.w600,
                height: 1, // Remove extra vertical spacing
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  StarPainter({
    required this.color,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = _createStarPath(size);
    canvas.drawPath(path, paint);
  }

  Path _createStarPath(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    for (int i = 0; i < 5; i++) {
      final angle = -math.pi / 2 + i * math.pi * 2 / 5;
      final point = Offset(
        centerX + math.cos(angle) * radius,
        centerY + math.sin(angle) * radius,
      );
      final innerAngle = angle + math.pi / 5;
      final innerPoint = Offset(
        centerX + math.cos(innerAngle) * (radius * 0.4),
        centerY + math.sin(innerAngle) * (radius * 0.4),
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
      path.lineTo(innerPoint.dx, innerPoint.dy);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.borderColor != borderColor;
  }
}
