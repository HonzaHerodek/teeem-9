import 'package:flutter/material.dart';
import '../../../data/models/traits/trait_type_model.dart';
import '../../../data/models/traits/user_trait_model.dart';

class UserTraitChip extends StatefulWidget {
  final UserTraitModel trait;
  final TraitTypeModel traitType;
  final double? width;
  final double height;
  final double spacing;
  final bool isSelected;
  final bool canEditType;
  final bool canEditValue;
  final VoidCallback? onTap;
  final Function(TraitTypeModel)? onTraitTypeEdit;
  final Function(UserTraitModel)? onTraitValueEdit;

  const UserTraitChip({
    super.key,
    required this.trait,
    required this.traitType,
    this.width,
    this.height = 35,
    this.spacing = 15,
    this.isSelected = false,
    this.canEditType = false,
    this.canEditValue = false,
    this.onTap,
    this.onTraitTypeEdit,
    this.onTraitValueEdit,
  });

  @override
  State<UserTraitChip> createState() => _UserTraitChipState();
}

class _UserTraitChipState extends State<UserTraitChip> {
  bool _isShowingValue = false;
  bool _isEditingValue = false;
  bool _isPrivate = false;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController.text = widget.trait.value;
    _focusNode.addListener(_onFocusChange);
    
    // Show value view by default when:
    // 1. Both edit types are false, OR
    // 2. Can't edit type and value is not empty
    _isShowingValue = (!widget.canEditType && !widget.canEditValue) || 
                     (!widget.canEditType && widget.trait.value.isNotEmpty);
  }

  @override
  void didUpdateWidget(UserTraitChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update showing value state when widget properties change
    if (oldWidget.canEditType != widget.canEditType || 
        oldWidget.canEditValue != widget.canEditValue ||
        oldWidget.trait.value != widget.trait.value) {
      setState(() {
        _isShowingValue = (!widget.canEditType && !widget.canEditValue) || 
                         (!widget.canEditType && widget.trait.value.isNotEmpty);
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      setState(() {
        _isEditingValue = false;
      });
    }
  }

  IconData? _parseIconData(String iconData) {
    try {
      final codePoint = int.parse(iconData, radix: 16);
      return IconData(codePoint, fontFamily: 'MaterialIcons');
    } catch (e) {
      return null;
    }
  }

  void _handleTypeTextTap() {
    if (widget.trait.value.isEmpty && widget.canEditValue) {
      // Start editing immediately if value is empty and editing is allowed
      setState(() {
        _isShowingValue = true;
        _isEditingValue = true;
        _textController.text = widget.trait.value;
      });
      _focusNode.requestFocus();
    } else {
      // Otherwise just show value view
      setState(() {
        _isShowingValue = true;
        if (widget.canEditType) {
          widget.onTraitTypeEdit?.call(widget.traitType);
        }
      });
    }
  }

  void _handleValueTextTap() {
    if (!widget.canEditValue) {
      // Toggle back to type view when value editing is not allowed
      setState(() {
        _isShowingValue = false;
      });
    } else if (!_isEditingValue) {
      // Start editing if allowed
      setState(() {
        _isEditingValue = true;
        _textController.text = widget.trait.value;
      });
      _focusNode.requestFocus();
    }
  }

  void _handleSubmitted(String value) {
    if (value.isNotEmpty && value != widget.trait.value) {
      widget.onTraitValueEdit?.call(widget.trait.copyWith(value: value));
    }
    setState(() {
      _isEditingValue = false;
    });
  }

  void _handleCancel() {
    setState(() {
      _isEditingValue = false;
      _isShowingValue = false;
    });
  }

  void _togglePrivacy() {
    setState(() {
      _isPrivate = !_isPrivate;
    });
  }

  double _calculateChipWidth() {
    if (_isEditingValue) {
      // Fixed width for editing mode to prevent overflow
      return widget.height * (widget.canEditType ? 6 : 5); // icon + textfield + (privacy if editable) + minimal padding
    }

    final text = _isShowingValue ? widget.trait.value : widget.traitType.name;
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.white,
        fontSize: _isShowingValue ? 13 : 11,
        fontWeight: _isShowingValue ? FontWeight.w600 : FontWeight.w400,
        letterSpacing: _isShowingValue ? 0.2 : 0.3,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    // icon + text + minimal padding
    return (widget.height + textPainter.width + 24).clamp(widget.height * 2.5, widget.height * 6);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isShowingValue && !widget.canEditValue ? 
        () => setState(() => _isShowingValue = false) : 
        widget.onTap,
      child: Container(
        width: widget.width ?? _calculateChipWidth(),
        height: widget.height,
        margin: EdgeInsets.only(right: widget.spacing / 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.white.withOpacity(widget.isSelected ? 0.2 : 0.15),
              Colors.white.withOpacity(widget.isSelected ? 0.15 : 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(widget.height / 2),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Left icon area - either trait icon or cancel button
            SizedBox(
              width: widget.height,
              height: widget.height,
              child: _isEditingValue
                ? GestureDetector(
                    onTap: _handleCancel,
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  )
                : GestureDetector(
                    onTap: () => setState(() => _isShowingValue = !_isShowingValue),
                    child: Icon(
                      _parseIconData(widget.traitType.iconData) ?? Icons.star,
                      color: Colors.white,
                      size: widget.height * 0.6,
                    ),
                  ),
            ),
            // Content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: _isEditingValue
                  ? Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: TextField(
                              controller: _textController,
                              focusNode: _focusNode,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                                height: 1.1,
                              ),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                border: InputBorder.none,
                                isDense: true,
                                hintText: widget.trait.value.isEmpty ? 'add info' : null,
                                hintStyle: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.2,
                                  height: 1.1,
                                ),
                              ),
                              onSubmitted: _handleSubmitted,
                            ),
                          ),
                        ),
                        if (widget.canEditType)
                          GestureDetector(
                            onTap: _togglePrivacy,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(
                                _isPrivate ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white,
                                size: widget.height * 0.6,
                              ),
                            ),
                          ),
                      ],
                    )
                  : GestureDetector(
                      onTap: _isShowingValue ? _handleValueTextTap : _handleTypeTextTap,
                      child: Text(
                        _isShowingValue ? widget.trait.value : widget.traitType.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: _isShowingValue ? 13 : 11,
                          fontWeight: _isShowingValue ? FontWeight.w600 : FontWeight.w400,
                          letterSpacing: _isShowingValue ? 0.2 : 0.3,
                          height: 1.1,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
