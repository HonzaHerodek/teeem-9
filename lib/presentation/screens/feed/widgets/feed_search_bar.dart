import 'package:flutter/material.dart';
import '../models/filter_type.dart';

class FeedSearchBar extends StatefulWidget {
  final FilterType filterType;
  final ValueChanged<String> onSearch;
  final VoidCallback onClose;

  const FeedSearchBar({
    super.key,
    required this.filterType,
    required this.onSearch,
    required this.onClose,
  });

  @override
  State<FeedSearchBar> createState() => _FeedSearchBarState();
}

class _FeedSearchBarState extends State<FeedSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      height: 40, // Match button height
      constraints: const BoxConstraints(maxWidth: 280),
      margin: const EdgeInsets.symmetric(vertical: 12), // Center vertically in header
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.95), // Updated opacity to 95%
        borderRadius: BorderRadius.circular(20), // Half of height
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: TextStyle(
          color: theme.textTheme.bodyLarge?.color ?? Colors.white,
          fontSize: 14, // Match button text size
        ),
        cursorColor: theme.primaryColor,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          hintText: widget.filterType.searchPlaceholder,
          hintStyle: TextStyle(
            color: theme.textTheme.bodyLarge?.color?.withOpacity(0.5) ?? Colors.white.withOpacity(0.5),
            fontSize: 14, // Match button text size
          ),
          prefixIcon: Icon(
            widget.filterType.icon,
            color: theme.primaryColor,
            size: 20,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 40,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.close,
              color: theme.iconTheme.color?.withOpacity(0.7),
              size: 20,
            ),
            onPressed: () {
              _controller.clear();
              widget.onClose();
            },
            splashRadius: 20,
            constraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            padding: EdgeInsets.zero,
          ),
          border: InputBorder.none,
        ),
        onChanged: widget.onSearch,
        textInputAction: TextInputAction.search,
        onSubmitted: widget.onSearch,
      ),
    );
  }
}
