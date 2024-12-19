import 'package:flutter/material.dart';
import 'dart:ui';

class ScrollableTraitList<T> extends StatefulWidget {
  final List<T> items;
  final T? selectedItem;
  final Widget Function(T item, bool isSelected, double scale) itemBuilder;
  final Function(T item) onItemSelected;
  final String hintText;
  final double itemHeight;
  final double maxHeight;
  final Widget Function(T item, double scale)? iconBuilder;

  ScrollableTraitList({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.itemBuilder,
    required this.onItemSelected,
    required this.hintText,
    this.itemHeight = 24,
    this.maxHeight = 40,
    this.iconBuilder,
  }) {
    assert(items.isNotEmpty, 'Items list cannot be empty');
  }

  @override
  State<ScrollableTraitList<T>> createState() => _ScrollableTraitListState<T>();
}

class _ScrollableTraitListState<T> extends State<ScrollableTraitList<T>> {
  late FixedExtentScrollController _scrollController;
  late T _centeredItem;
  final int _multiplier = 1000; // For infinite scrolling

  @override
  void initState() {
    super.initState();
    _centeredItem = widget.selectedItem ?? widget.items.first;
    final initialIndex = widget.selectedItem != null 
        ? widget.items.indexOf(widget.selectedItem!) + (widget.items.length * _multiplier ~/ 2)
        : (widget.items.length * _multiplier ~/ 2);
    
    _scrollController = FixedExtentScrollController(
      initialItem: initialIndex,
    );
  }

  @override
  void didUpdateWidget(ScrollableTraitList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != oldWidget.selectedItem) {
      _centeredItem = widget.selectedItem ?? widget.items.first;
      if (_scrollController.hasClients) {
        final targetIndex = widget.selectedItem != null 
            ? widget.items.indexOf(widget.selectedItem!) + (widget.items.length * _multiplier ~/ 2)
            : (widget.items.length * _multiplier ~/ 2);
        _scrollController.jumpToItem(targetIndex);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleItemChanged(int index) {
    if (!mounted) return;
    final selectedIndex = index % widget.items.length;
    final newCenteredItem = widget.items[selectedIndex];
    if (_centeredItem != newCenteredItem) {
      setState(() {
        _centeredItem = newCenteredItem;
      });
      widget.onItemSelected(newCenteredItem);
    }
  }

  double _calculateScale(int index) {
    if (!_scrollController.hasClients) return 1.0;
    
    final selectedItem = _scrollController.selectedItem;
    final distance = (index - selectedItem).abs();
    
    const maxScale = 1.0;
    const minScale = 0.6;
    const scalingFactor = 0.2;
    
    double scale = maxScale - (distance * scalingFactor);
    return scale.clamp(minScale, maxScale);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.iconBuilder != null) ...[
          widget.iconBuilder!(_centeredItem, 1.0),
          const SizedBox(width: 4),
        ],
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: widget.maxHeight,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  // Center indicator
                  Positioned(
                    top: (widget.maxHeight - widget.itemHeight) / 2,
                    left: 0,
                    right: 0,
                    height: widget.itemHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Hint text when no selection
                  if (widget.selectedItem == null)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          widget.hintText,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  // List of items
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.9),
                        ],
                        stops: const [0.0, 0.2, 0.8, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstOut,
                    child: ListWheelScrollView(
                      controller: _scrollController,
                      itemExtent: widget.itemHeight,
                      perspective: 0.0025,
                      diameterRatio: 1.4,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: _handleItemChanged,
                      useMagnifier: true,
                      magnification: 1.1,
                      overAndUnderCenterOpacity: 0.6,
                      children: List.generate(
                        widget.items.length * _multiplier,
                        (index) {
                          final actualIndex = index % widget.items.length;
                          final item = widget.items[actualIndex];
                          final isSelected = item == widget.selectedItem;
                          final scale = _calculateScale(index);
                          
                          return Container(
                            height: widget.itemHeight,
                            alignment: Alignment.center,
                            child: widget.itemBuilder(item, isSelected, scale),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
