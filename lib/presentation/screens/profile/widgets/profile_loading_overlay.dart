import 'package:flutter/material.dart';

class ProfileLoadingOverlay extends StatelessWidget {
  final bool isInitialLoading;

  const ProfileLoadingOverlay({
    super.key,
    this.isInitialLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: isInitialLoading 
          ? Colors.transparent
          : Colors.black.withOpacity(0.3),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
          ),
        ),
      ),
    );
  }
}
