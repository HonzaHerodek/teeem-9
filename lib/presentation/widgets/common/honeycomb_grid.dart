import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Defines the layout style for the honeycomb grid
enum HoneycombLayout {
  /// Items arranged in a horizontal line with optional curvature
  horizontalLine,
  
  /// Items arranged in a vertical line with optional curvature
  verticalLine,
  
  /// Items arranged in a honeycomb pattern filling an area
  area
}

/// Configuration for the honeycomb grid layout
class HoneycombConfig {
  /// The type of layout to use
  final HoneycombLayout layout;
  
  /// Curvature amount for line layouts (0.0 to 1.0)
  /// 0.0 = straight line, 1.0 = maximum curve
  final double curvature;
  
  /// Maximum width for area layout (items will wrap within this width)
  final double? maxWidth;
  
  /// Maximum number of items per row for area layout
  final int? maxItemsPerRow;

  const HoneycombConfig({
    required this.layout,
    this.curvature = 0.0,
    this.maxWidth,
    this.maxItemsPerRow,
  }) : assert(curvature >= 0.0 && curvature <= 1.0),
       assert(layout != HoneycombLayout.area || maxWidth != null,
           'maxWidth is required for area layout');

  /// Preset for horizontal line with no curve
  static const horizontal = HoneycombConfig(
    layout: HoneycombLayout.horizontalLine,
    curvature: 0.0,
  );

  /// Preset for vertical line with no curve
  static const vertical = HoneycombConfig(
    layout: HoneycombLayout.verticalLine,
    curvature: 0.0,
  );

  /// Creates an area layout configuration
  static HoneycombConfig area({
    required double maxWidth,
    int maxItemsPerRow = 3,
  }) => HoneycombConfig(
    layout: HoneycombLayout.area,
    maxWidth: maxWidth,
    maxItemsPerRow: maxItemsPerRow,
  );
}

class HoneycombGrid extends StatelessWidget {
  final List<Widget> children;
  final double cellSize;
  final double spacing;
  final HoneycombConfig config;

  const HoneycombGrid({
    Key? key,
    required this.children,
    required this.cellSize,
    required this.config,
    this.spacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox();

    switch (config.layout) {
      case HoneycombLayout.horizontalLine:
        return _buildHorizontalLine();
      case HoneycombLayout.verticalLine:
        return _buildVerticalLine();
      case HoneycombLayout.area:
        return _buildArea();
    }
  }

  Widget _buildHorizontalLine() {
    final width = children.length * (cellSize + spacing) - spacing;
    final height = cellSize + (config.curvature * cellSize);

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: List.generate(children.length, (index) {
          final x = index * (cellSize + spacing);
          // Apply sine wave for curvature
          final y = config.curvature * cellSize * 
              math.sin(index * math.pi / (children.length - 1));

          return Positioned(
            left: x,
            top: y,
            child: SizedBox(
              width: cellSize,
              height: cellSize,
              child: children[index],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildVerticalLine() {
    final width = cellSize + (config.curvature * cellSize);
    final height = children.length * (cellSize + spacing) - spacing;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: List.generate(children.length, (index) {
          final y = index * (cellSize + spacing);
          // Apply sine wave for curvature
          final x = config.curvature * cellSize * 
              math.sin(index * math.pi / (children.length - 1));

          return Positioned(
            left: x,
            top: y,
            child: SizedBox(
              width: cellSize,
              height: cellSize,
              child: children[index],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildArea() {
    if (children.length <= 2) {
      // Two or fewer items: horizontal line
      return _buildHorizontalLine();
    }
    
    if (children.length == 3) {
      // Three items: triangle formation
      return SizedBox(
        width: cellSize * 2 + spacing,
        height: cellSize * 2,
        child: Stack(
          children: [
            // Top center
            Positioned(
              left: cellSize / 2,
              child: SizedBox(
                width: cellSize,
                height: cellSize,
                child: children[0],
              ),
            ),
            // Bottom left
            Positioned(
              top: cellSize,
              child: SizedBox(
                width: cellSize,
                height: cellSize,
                child: children[1],
              ),
            ),
            // Bottom right
            Positioned(
              left: cellSize + spacing,
              top: cellSize,
              child: SizedBox(
                width: cellSize,
                height: cellSize,
                child: children[2],
              ),
            ),
          ],
        ),
      );
    }

    // More than 3 items: honeycomb pattern
    final itemsPerRow = config.maxItemsPerRow ?? 3;
    final rowCount = (children.length / itemsPerRow).ceil();
    final height = (rowCount * cellSize * 0.866) + cellSize;

    return SizedBox(
      width: config.maxWidth,
      height: height,
      child: Stack(
        children: _positionAreaChildren(),
      ),
    );
  }

  List<Widget> _positionAreaChildren() {
    final List<Widget> positioned = [];
    int itemCount = 0;
    int row = 0;

    while (itemCount < children.length) {
      final isEvenRow = row % 2 == 0;
      final itemsPerRow = config.maxItemsPerRow ?? 3;
      final itemsInThisRow = math.min(itemsPerRow, children.length - itemCount);
      
      for (int col = 0; col < itemsInThisRow; col++) {
        // Calculate position
        final x = (isEvenRow ? 0 : cellSize * 0.5) + (col * (cellSize + spacing));
        final y = row * cellSize * 0.75;

        positioned.add(
          Positioned(
            left: x,
            top: y,
            child: SizedBox(
              width: cellSize,
              height: cellSize,
              child: children[itemCount],
            ),
          ),
        );
        
        itemCount++;
      }
      row++;
    }

    return positioned;
  }
}

/// A clipper that creates a hexagonal shape
class HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;
    final centerX = width / 2;
    final centerY = height / 2;
    final radius = math.min(width, height) / 2;

    // Start from the rightmost point and move counterclockwise
    path.moveTo(centerX + radius, centerY);
    
    for (int i = 1; i <= 6; i++) {
      final angle = i * 60 * math.pi / 180;
      path.lineTo(
        centerX + radius * math.cos(angle),
        centerY + radius * math.sin(angle),
      );
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
