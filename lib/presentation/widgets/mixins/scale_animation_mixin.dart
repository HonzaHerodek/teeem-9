import 'package:flutter/material.dart';

mixin ScaleAnimationMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  static const Duration _scaleDuration = Duration(milliseconds: 150);
  static const double _maxScale = 1.05;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: _scaleDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: _maxScale,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void scaleUp() {
    _scaleController.forward();
  }

  void scaleDown() {
    _scaleController.reverse();
  }

  Animation<double> get scaleAnimation => _scaleAnimation;
}
