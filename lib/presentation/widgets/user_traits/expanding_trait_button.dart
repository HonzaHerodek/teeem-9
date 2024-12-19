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
  final double collapsedWidth = 48; // Match parent container minimum width

  @override
  void initState() {
    super.initState();
    // Calculate minimum width based on longest trait type name
    final longestTraitName = widget.traitTypes.fold<int>(
      0,
      (maxLength, trait) =>
          trait.name.length > maxLength ? trait.name.length : maxLength,
    );
    // More compact width calculation:
    // 40 (icon) + 120 (trait list) + 8 (spacing) + 50 (value list) + 40 (button)
    expandedWidth =
        math.min(258, math.max(220, (longestTraitName * 5.0) + 120));
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

  void _handleExpandButtonTap() {
    setState(() => isExpanded = true);
  }

  void _handleConfirmButtonTap() {
    if (selectedTraitType != null && selectedValue != null) {
      _handleTraitSelection();
    }
  }

  Widget _buildTraitItem(TraitTypeModel type, bool isSelected, double scale) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: isSelected
          ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(4),
            )
          : null,
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
      decoration: isSelected
          ? BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.15),
                ],
              ),
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            )
          : null,
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
            _parseIconData(type.iconData) ?? Icons.star,
            color: Colors.white,
            size: widget.height * 0.6 * scale,
          ),
        ],
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
      clipBehavior: Clip.antiAlias, // Prevent overflow during animation
      child: Material(
        color: Colors.transparent,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isExpanded)
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _handleExpandButtonTap,
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
                          Icons.add,
                          color: Colors.white,
                          size: widget.height * 0.6,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else ...[
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 120,
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
                        width: 50,
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
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: canConfirm ? _handleConfirmButtonTap : null,
                  borderRadius: BorderRadius.circular(widget.height / 2),
                  child: Container(
                    width: widget.height,
                    height: widget.height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.white.withOpacity(canConfirm ? 0.35 : 0.15),
                          Colors.white.withOpacity(canConfirm ? 0.3 : 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(widget.height / 2),
                        bottomRight: Radius.circular(widget.height / 2),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white.withOpacity(canConfirm ? 1.0 : 0.3),
                        size: widget.height * 0.6,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
