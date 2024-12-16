import 'package:flutter/material.dart';
import 'dart:math' as math;

class RatingStars extends StatefulWidget {
  final double rating;
  final double size;
  final bool isInteractive;
  final Function(double)? onRatingChanged;
  final Color? color;
  final Map<int, int>? distribution;
  final int? totalRatings;
  final bool showRatingText;
  final Function(bool)? onExpanded;

  const RatingStars({
    Key? key,
    required this.rating,
    this.size = 24.0,
    this.isInteractive = false,
    this.onRatingChanged,
    this.color,
    this.distribution,
    this.totalRatings,
    this.showRatingText = false,
    this.onExpanded,
  }) : super(key: key);

  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  bool _expanded = false;

  Widget _buildCurvedStars() {
    return SizedBox(
      width: 160,
      height: 50,
      child: CustomPaint(
        size: const Size(160, 50),
        painter: CurvedStarsPainter(
          rating: widget.rating,
          starSize: widget.size,
          color: widget.color ?? Colors.amber,
        ),
      ),
    );
  }

  Widget _buildRatingStats() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showRatingText && widget.distribution != null && widget.totalRatings != null)
          Text(
            '${widget.rating.toStringAsFixed(1)} (${widget.totalRatings} ${widget.totalRatings == 1 ? 'rating' : 'ratings'})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.distribution != null && widget.totalRatings != null) ...[
          const SizedBox(height: 16),
          Text(
            'Rating Distribution',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 5; i >= 1; i--)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$i star',
                    style: const TextStyle(color: Colors.amber),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 150,
                    child: LinearProgressIndicator(
                      value: widget.totalRatings! > 0
                          ? (widget.distribution![i] ?? 0) / widget.totalRatings!
                          : 0,
                      backgroundColor: Colors.grey[800],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.distribution![i] ?? 0}',
                    style: const TextStyle(color: Colors.amber),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MouseRegion(
          cursor: widget.distribution != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: widget.distribution != null ? () {
              setState(() {
                _expanded = !_expanded;
                widget.onExpanded?.call(_expanded);
              });
            } : null,
            child: _buildCurvedStars(),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _buildRatingStats(),
          ),
          crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}

class CurvedStarsPainter extends CustomPainter {
  final double rating;
  final double starSize;
  final Color color;

  CurvedStarsPainter({
    required this.rating,
    required this.starSize,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Calculate positions for stars along a very gentle curve
    final starSpacing = size.width / 3.6; // Adjusted spacing for larger stars
    final curveHeight = 43.0;
    
    // Calculate the middle star's position first
    final middleX = size.width / 2;
    final middleY = size.height - starSize / 2;
    
    for (int i = 0; i < 5; i++) {
      // Calculate x position with increased spacing
      final progress = i / 4;
      final x = (size.width - starSpacing * 4) / 2 + starSpacing * i;
      
      // Calculate y position using a parabolic curve
      final normalizedX = progress * 2 - 1; // -1 to 1
      final y = middleY - curveHeight * (1 - normalizedX * normalizedX);
      
      // Calculate gradually increasing size (8% increase per star)
      final sizeMultiplier = 1.0 + (i * 0.08);
      final currentStarSize = starSize * sizeMultiplier;
      
      final starValue = i + 1;
      final isHalfStar = rating > i && rating < starValue;
      final isFullStar = rating >= starValue;

      if (isFullStar) {
        _drawStar(canvas, Offset(x, y), currentStarSize, paint);
      } else if (isHalfStar) {
        _drawHalfStar(canvas, Offset(x, y), currentStarSize, paint);
      } else {
        _drawStarBorder(canvas, Offset(x, y), currentStarSize, paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = _createStarPath(center, size);
    canvas.drawPath(path, paint);
  }

  void _drawHalfStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = _createStarPath(center, size);
    canvas.drawPath(path, paint..style = PaintingStyle.stroke..strokeWidth = 2);

    final halfPath = Path();
    final rect = Rect.fromCenter(center: center, width: size, height: size);
    halfPath.addRect(Rect.fromLTRB(rect.left, rect.top, center.dx, rect.bottom));
    canvas.drawPath(Path.combine(PathOperation.intersect, path, halfPath),
        paint..style = PaintingStyle.fill);
  }

  void _drawStarBorder(Canvas canvas, Offset center, double size, Paint paint) {
    final path = _createStarPath(center, size);
    canvas.drawPath(path, paint..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  Path _createStarPath(Offset center, double size) {
    final path = Path();
    final halfSize = size / 2;

    for (int i = 0; i < 5; i++) {
      final angle = -math.pi / 2 + i * math.pi * 2 / 5;
      final point = Offset(
        center.dx + math.cos(angle) * halfSize,
        center.dy + math.sin(angle) * halfSize,
      );
      final innerAngle = angle + math.pi / 5;
      final innerPoint = Offset(
        center.dx + math.cos(innerAngle) * (halfSize * 0.4),
        center.dy + math.sin(innerAngle) * (halfSize * 0.4),
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
  bool shouldRepaint(CurvedStarsPainter oldDelegate) {
    return oldDelegate.rating != rating ||
        oldDelegate.starSize != starSize ||
        oldDelegate.color != color;
  }
}
