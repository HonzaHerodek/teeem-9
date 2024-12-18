import 'package:flutter/material.dart';

class DebugOverlay {
  static OverlayEntry? _entry;
  static final List<String> _messages = [];
  static const int _maxMessages = 5;
  static const Duration _displayDuration = Duration(seconds: 3);

  static void show(BuildContext context, String message) {
    _messages.insert(0, message);
    if (_messages.length > _maxMessages) {
      _messages.removeLast();
    }

    _entry?.remove();
    _entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 100,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Column(
            children: _messages.map((msg) => _buildMessage(msg)).toList(),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_entry!);

    Future.delayed(_displayDuration, () {
      if (_messages.contains(message)) {
        _messages.remove(message);
        _entry?.remove();
        if (_messages.isNotEmpty) {
          show(context, _messages.first);
        }
      }
    });
  }

  static Widget _buildMessage(String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}

void showDebug(BuildContext context, String message) {
  DebugOverlay.show(context, message);
}
