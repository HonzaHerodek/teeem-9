import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../data/models/traits/trait_type_model.dart';
import 'scrollable_trait_list.dart';

class ExpandingTraitButton extends StatefulWidget {
  final List<TraitTypeModel> traitTypes;
  final Function(TraitTypeModel traitType, String value) onTraitSelected;
  final double height;

  const ExpandingTraitButton({
    super.key,
    required this.traitTypes,
    required this.onTraitSelected,
    required this.height,
  });

  @override
  State<ExpandingTraitButton> createState() => _ExpandingTraitButtonState();
}

class _ExpandingTraitButtonState extends State<ExpandingTraitButton> {
  bool isExpanded = false;
  TraitTypeModel? selectedTraitType;
  String? selectedValue;
  late final double expandedWidth;
  final double collapsedWidth = 40;

  @override
  void initState() {
    super.initState();
    // Calculate minimum width based on longest trait type name
    final longestTraitName = widget.traitTypes.fold<int>(
      0,
      (maxLength, trait) => trait.name.length > maxLength ? trait.name.length : maxLength,
    );
    // Approximate width calculation: 
    // 40 (icon) + 160 (trait list) + 8 (spacing) + 60 (value list) + 40 (button)
    expandedWidth = math.min(308, math.max(260, (longestTraitName * 6.0) + 140));
  }

  IconData? _parseIconData(String iconData) {
    try {
      final codePoint = int.parse(iconData, radix: 16);
      return IconData(codePoint, fontFamily: 'MaterialIcons');
    } catch (e) {
      return null;
    }
  }

  void _resetState() {
    setState(() {
      isExpanded = false;
      selectedTraitType = null;
      selectedValue = null;
    });
  }

  void _handleTraitSelection() {
    if (selectedTraitType != null && selectedValue != null) {
      widget.onTraitSelected(selectedTraitType!, selectedValue!);
      _resetState();
    }
  }

  void _handleButtonTap() {
    if (!isExpanded) {
      setState(() => isExpanded = true);
    } else if (selectedTraitType != null && selectedValue != null) {
      _handleTraitSelection();
    }
  }

  Widget _buildTraitItem(TraitTypeModel type, bool isSelected, double scale) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: isSelected ? BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ) : null,
      child: Text(
        type.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          height: 1.0,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildValueItem(String value, bool isSelected, double scale) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: isSelected ? BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ) : null,
      child: Center(
        child: Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            height: 1.0,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildTraitIcon(TraitTypeModel type, double scale) {
    return Container(
      width: widget.height,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(widget.height / 2),
      ),
      child: Center(
        child: Icon(
          _parseIconData(type.iconData) ?? Icons.star,
          color: Colors.white,
          size: widget.height * 0.6 * scale,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canConfirm = selectedTraitType != null && selectedValue != null;
    final wheelHeight = widget.height * 3;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isExpanded ? expandedWidth : collapsedWidth,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(widget.height / 2),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleButtonTap,
          borderRadius: BorderRadius.circular(widget.height / 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!isExpanded)
                Container(
                  width: widget.height,
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(widget.height / 2),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: widget.height * 0.6,
                    ),
                  ),
                )
              else ...[
                Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 160,
                        child: ScrollableTraitList<TraitTypeModel>(
                          items: widget.traitTypes,
                          selectedItem: selectedTraitType,
                          itemBuilder: _buildTraitItem,
                          onItemSelected: (type) {
                            setState(() {
                              selectedTraitType = type;
                              selectedValue = null;
                            });
                          },
                          hintText: 'Trait',
                          maxHeight: widget.height,
                          itemHeight: 24,
                          iconBuilder: _buildTraitIcon,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (selectedTraitType != null)
                        SizedBox(
                          width: 60,
                          child: ScrollableTraitList<String>(
                            items: selectedTraitType!.possibleValues,
                            selectedItem: selectedValue,
                            itemBuilder: _buildValueItem,
                            onItemSelected: (value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                            hintText: 'Value',
                            maxHeight: widget.height,
                            itemHeight: 24,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: widget.height,
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(widget.height / 2),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        canConfirm ? Icons.check : Icons.add,
                        key: ValueKey(canConfirm),
                        color: Colors.white,
                        size: widget.height * 0.6,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
