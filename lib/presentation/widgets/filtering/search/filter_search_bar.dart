import 'package:flutter/material.dart';
import '../models/filter_type.dart';

class FilterSearchBar extends StatefulWidget {
  final FilterType filterType;
  final ValueChanged<String> onSearch;
  final VoidCallback onClose;

  const FilterSearchBar({
    super.key,
    required this.filterType,
    required this.onSearch,
    required this.onClose,
  });

  @override
  State<FilterSearchBar> createState() => _FilterSearchBarState();
}

class _FilterSearchBarState extends State<FilterSearchBar> {
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
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: widget.filterType.searchPlaceholder,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          prefixIcon: Icon(widget.filterType.icon, color: Colors.white),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              _controller.clear();
              widget.onClose();
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onChanged: widget.onSearch,
      ),
    );
  }
}
