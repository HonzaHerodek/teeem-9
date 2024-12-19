import 'package:flutter/material.dart';
import '../../../data/models/notification_model.dart';

class NotificationBar extends StatefulWidget {
  final List<NotificationModel> notifications;
  final Function(NotificationModel) onNotificationSelected;
  final VoidCallback onClose;
  final GlobalKey? barKey;

  const NotificationBar({
    super.key,
    required this.notifications,
    required this.onNotificationSelected,
    required this.onClose,
    this.barKey,
  });

  @override
  State<NotificationBar> createState() => _NotificationBarState();
}

class _NotificationBarState extends State<NotificationBar> {
  late FixedExtentScrollController _scrollController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleIndexChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onNotificationSelected(widget.notifications[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.barKey,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Navigation arrows container
          Container(
            width: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(28)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Up arrow
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: _currentIndex > 0
                          ? () {
                              _scrollController.animateToItem(
                                _currentIndex - 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.white.withOpacity(
                          _currentIndex > 0 ? 1.0 : 0.5,
                        ),
                        size: 16,
                      ),
                    ),
                  ),
                ),
                // Down arrow
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onTap: _currentIndex < widget.notifications.length - 1
                          ? () {
                              _scrollController.animateToItem(
                                _currentIndex + 1,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white.withOpacity(
                          _currentIndex < widget.notifications.length - 1
                              ? 1.0
                              : 0.5,
                        ),
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Notification count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${_currentIndex + 1}/${widget.notifications.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
          // Notifications ListWheelScrollView
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ListWheelScrollView.useDelegate(
                controller: _scrollController,
                itemExtent: 40,
                perspective: 0.005,
                diameterRatio: 2.0,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: _handleIndexChanged,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: widget.notifications.length,
                  builder: (context, index) {
                    final notification = widget.notifications[index];
                    return Center(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: _currentIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
