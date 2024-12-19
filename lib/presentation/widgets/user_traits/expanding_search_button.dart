import 'package:flutter/material.dart';

class ExpandingSearchButton extends StatefulWidget {
  final double height;
  final Function(String searchText) onSearch;

  const ExpandingSearchButton({
    super.key,
    required this.height,
    required this.onSearch,
  });

  @override
  State<ExpandingSearchButton> createState() => _ExpandingSearchButtonState();
}

class _ExpandingSearchButtonState extends State<ExpandingSearchButton> {
  bool isExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  final double collapsedWidth = 48; // Match parent container minimum width
  final double expandedWidth = 160; // Slightly increased for better text input space

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleButtonTap() {
    setState(() => isExpanded = !isExpanded);
    if (!isExpanded) {
      _searchController.clear();
      widget.onSearch('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isExpanded ? expandedWidth : collapsedWidth,
      height: widget.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(widget.height / 2),
          bottomRight: Radius.circular(widget.height / 2),
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            InkWell(
              onTap: _handleButtonTap,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(widget.height / 2),
                bottomRight: Radius.circular(widget.height / 2),
              ),
              child: Container(
                width: widget.height,
                height: widget.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(widget.height / 2),
                    bottomRight: Radius.circular(widget.height / 2),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.search,
                      color: Colors.white,
                      size: widget.height * 0.6,
                    ),
                    if (!isExpanded)
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.3),
                                Colors.white.withOpacity(0.2),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: widget.height * 0.25,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (isExpanded)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.0,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: widget.onSearch,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
